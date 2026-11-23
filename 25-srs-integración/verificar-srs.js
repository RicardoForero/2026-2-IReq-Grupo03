#!/usr/bin/env node
/**
 * verificar-srs.js — Script de verificación automatizada Docs as Code
 * Proyecto: SRS-SICIRD-001 v1.0 (La Tradición) · Línea Base LB-1.0 (srs-v1.0)
 * Uso: node verificar-srs.js
 */

const fs = require('fs');
const path = require('path');

const jsonPath = path.join(__dirname, 'srs-sicird-001.json');
const featurePath = path.join(__dirname, 'escenarios.feature');

if (!fs.existsSync(jsonPath) || !fs.existsSync(featurePath)) {
  console.error('[ERROR FATAL] No se encontraron srs-sicird-001.json o escenarios.feature en el directorio.');
  process.exit(1);
}

const srs = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));
const featureContent = fs.readFileSync(featurePath, 'utf8');

const erroresBloqueantes = [];
const advertenciasDeclaradas = [];

// Catálogos de referencia
const niIds = new Set(srs.necesidades_negocio.map(x => x.id));
const gIds = new Set(srs.metas_proyecto.map(x => x.id));
const huIds = new Set(srs.historias_usuario.map(x => x.id));
const cuIds = new Set(srs.casos_uso.map(x => x.id));
const rfAll = srs.requisitos_funcionales;
const rfPadre = rfAll.filter(x => x.tipo === 'padre');
const rfAtomicos = rfAll.filter(x => x.tipo === 'atomico');
const rnfAll = srs.requisitos_no_funcionales;
const rnIds = new Set(srs.reglas_negocio.map(x => x.id));
const pIds = new Set(srs.pantallas.map(x => x.id));
const mIds = new Set(srs.mensajes.map(x => x.id));
const acIds = new Set(srs.criterios_aceptacion.map(x => x.id));
const verIds = new Set(srs.casos_verificacion.map(x => x.id));
const pdMap = new Map(srs.pendientes_declarados.map(x => [x.id, x]));

// 1. Verificar integridad G -> NI
for (const g of srs.metas_proyecto) {
  if (!niIds.has(g.ni_id)) {
    erroresBloqueantes.push(`Meta ${g.id} apunta a NI inexistente: ${g.ni_id}`);
  }
}

// 2. Verificar integridad HU -> G y detección de HU postergadas/condicionales
for (const hu of srs.historias_usuario) {
  if (!gIds.has(hu.g_id)) {
    erroresBloqueantes.push(`Historia ${hu.id} apunta a Meta inexistente: ${hu.g_id}`);
  }
  if (hu.estado === 'Postergada Fase 2') {
    advertenciasDeclaradas.push(`[EXCLUSIÓN DECLARADA] ${hu.id} (${hu.titulo}) postergada a Fase 2 (sin RF en v1.0).`);
  }
}

// 3. Verificar integridad CU -> HU
for (const cu of srs.casos_uso) {
  if (!huIds.has(cu.hu_id)) {
    erroresBloqueantes.push(`Caso de uso ${cu.id} apunta a HU inexistente: ${cu.hu_id}`);
  }
}

// 4. Verificar integridad de Requisitos Funcionales Atómicos
for (const rf of rfAtomicos) {
  if (!huIds.has(rf.hu_id)) erroresBloqueantes.push(`${rf.id}: HU inexistente (${rf.hu_id})`);
  if (!cuIds.has(rf.cu_id)) erroresBloqueantes.push(`${rf.id}: CU inexistente (${rf.cu_id})`);
  for (const rn of rf.reglas) {
    if (!rnIds.has(rn)) erroresBloqueantes.push(`${rf.id}: RN inexistente (${rn})`);
  }
  for (const p of rf.pantallas) {
    if (!pIds.has(p)) erroresBloqueantes.push(`${rf.id}: Pantalla inexistente (${p})`);
  }
  for (const m of rf.mensajes) {
    if (!mIds.has(m)) erroresBloqueantes.push(`${rf.id}: Mensaje inexistente (${m})`);
  }
  for (const ac of rf.criterios) {
    if (!acIds.has(ac)) erroresBloqueantes.push(`${rf.id}: Criterio AC inexistente (${ac})`);
  }
  for (const v of rf.verificacion) {
    if (!verIds.has(v)) erroresBloqueantes.push(`${rf.id}: Verificación inexistente (${v})`);
  }
  for (const pd of rf.pendientes) {
    if (!pdMap.has(pd)) {
      erroresBloqueantes.push(`${rf.id}: Pendiente PD no declarado (${pd})`);
    } else {
      const info = pdMap.get(pd);
      advertenciasDeclaradas.push(`[PENDIENTE DECLARADO] ${pd} en ${rf.id}: ${info.descripcion} (Dueño: ${info.dueno} · Límite: ${info.fecha_limite})`);
    }
  }
}

// 5. Verificar Requisitos No Funcionales
for (const rnf of rnfAll) {
  if (!huIds.has(rnf.hu_id)) erroresBloqueantes.push(`${rnf.id}: HU inexistente (${rnf.hu_id})`);
  if (!cuIds.has(rnf.cu_id)) erroresBloqueantes.push(`${rnf.id}: CU inexistente (${rnf.cu_id})`);
  for (const ac of rnf.criterios) {
    if (!acIds.has(ac)) erroresBloqueantes.push(`${rnf.id}: Criterio AC inexistente (${ac})`);
  }
  for (const v of rnf.verificacion) {
    if (!verIds.has(v)) erroresBloqueantes.push(`${rnf.id}: Verificación inexistente (${v})`);
  }
}

// 6. Verificar correspondencia 1 a 1 entre AC en JSON y Escenarios Gherkin en escenarios.feature
const escenariosEnFeature = (featureContent.match(/^\s*Escenario:\s+AC-\d+/gm) || []);
for (const ac of srs.criterios_aceptacion) {
  const regex = new RegExp(`Escenario:\\s+${ac.id}\\b`);
  if (!regex.test(featureContent)) {
    erroresBloqueantes.push(`Criterio ${ac.id} definido en JSON pero ausente en escenarios.feature`);
  }
}
if (escenariosEnFeature.length !== srs.criterios_aceptacion.length) {
  erroresBloqueantes.push(`Discrepancia de conteo Gherkin: JSON=${srs.criterios_aceptacion.length}, Feature=${escenariosEnFeature.length}`);
}

// 7. Verificar reglas postergadas declaradas
for (const rn of srs.reglas_negocio) {
  if (rn.estado === 'Postergada') {
    advertenciasDeclaradas.push(`[REGLA POSTERGADA] ${rn.id}: ${rn.nombre}`);
  }
}

// Salida del reporte
console.log('========================================================================');
console.log(`VERIFICADOR AUTOMATIZADO SRS — ${srs.meta.codigo} v${srs.meta.version} (${srs.meta.linea_base} / ${srs.meta.etiqueta_git})`);
console.log('========================================================================');
console.log(`- Necesidades de negocio (NI): ${srs.necesidades_negocio.length}`);
console.log(`- Metas del proyecto (G):      ${srs.metas_proyecto.length}`);
console.log(`- Historias de usuario (HU):   ${srs.historias_usuario.length} (7 activas en v1.0, 1 postergada a Fase 2)`);
console.log(`- Casos de uso (CU):           ${srs.casos_uso.length}`);
console.log(`- Requisitos Funcionales (RF): ${rfAll.length} (${rfPadre.length} padre + ${rfAtomicos.length} atómicos)`);
console.log(`- Requisitos No Func. (RNF):   ${rnfAll.length}`);
console.log(`- Total Requisitos (RF+RNF):   ${rfAll.length + rnfAll.length}`);
console.log(`- Reglas de Negocio (RN):      ${srs.reglas_negocio.length} (15 activas + 1 postergada)`);
console.log(`- Pantallas (P):               ${srs.pantallas.length} (P-00 a P-09)`);
console.log(`- Mensajes de catálogo (M):    ${srs.mensajes.length} (M-01 a M-15)`);
console.log(`- Escenarios Gherkin (AC):     ${escenariosEnFeature.length} verificados en escenarios.feature`);
console.log(`- Casos de Verificación:       ${srs.casos_verificacion.length} (13 CP, 2 IN, 2 DE, 1 AN)`);
console.log(`- Pendientes declarados (PD):  ${srs.pendientes_declarados.length} (PD-01 a PD-09)`);
console.log('------------------------------------------------------------------------');
console.log(`ERRORES BLOQUEANTES DE INTEGRIDAD: ${erroresBloqueantes.length}`);
if (erroresBloqueantes.length > 0) {
  erroresBloqueantes.forEach(e => console.error('  [X]', e));
  process.exit(1);
}
console.log('EXCEPCIONES Y PENDIENTES DECLARADOS CON DUEÑO Y FECHA:');
advertenciasDeclaradas.forEach(a => console.log('  [!]', a));
console.log('========================================================================');
console.log('RESULTADO: APROBADO — Línea base LB-1.0 íntegra y lista para traspaso.');
console.log('========================================================================');
