# PLANTILLA PARA DILIGENCIAR · UNIDAD 3 · SESIÓN 4

## Ingeniería de Requisitos — Backlog priorizado con MoSCoW

> **Criterio metodológico aplicado:** MoSCoW se prioriza siempre contra una entrega concreta con fecha (Lanzamiento v1.0 / MVP Operativo Q1 2027). *Must* corresponde a lo que impide lanzar o incumple una norma sanitaria/operativa crítica (≤ 60 % del esfuerzo total); *Should* cuenta con procedimiento alterno viable; *Could* representa mejoras de conveniencia; y *Won't* es una exclusión explícita para esta entrega con fecha programada de revisión.

---

### Datos generales del proyecto

| Campo | Detalle |
| :---- | :---- |
| **Nombre del proyecto** | Sistema de Control de Inventario y Optimización de Rutas de Distribución (SICIRD) — La Tradición (Planta Barrio Libertador, Tunja, Boyacá) |
| **Equipo e integrantes** | • Ricardo Forero Ortiz — `RicardoForero`<br>• Keiner Alberto Carvajal — `kriner2005`<br>• Diego Leonardo Cholo Largo — `diegocholo-bli`<br>• Yisel Matabajoy — `Yiyi345` |

| **Entrega contra la que se prioriza (alcance y fecha)** | **Versión 1.0 (MVP Operativo de Producción, Inventario FEFO y Distribución Rural Offline)** — Fecha compromiso de entrega en producción: **Q1 2027 (15 de febrero de 2027\)**, dentro del presupuesto aprobado por Gerencia (\$15.000.000 – \$20.000.000 COP). |

---

### 1\. Backlog clasificado

A continuación se clasifican las historias de usuario de la Sesión 3 (HU-01 a HU-08) junto con los ítems de alcance evaluados para la v1.0, ajustando la distribución tras aplicar la regla de capacidad del 60 % para *Must*:

| Requisito | Categoría (Must/Should/Could/Won't) | Justificación |
| :---- | :---- | :---- |
| **HU-01 (8 pts):** Registrar ingreso de lote con verificación y control sanitario (`CU-02`, `RF-001`) | **Must** | **Obligatorio por normativa INVIMA (R-3) y base del inventario.** Sin el registro único de lote y bloqueo automático de productos fuera de rango sanitario/térmico no existe trazabilidad ni rotación FEFO posible en planta. |
| **HU-03 (8 pts):** Crear entrega en bodega con selección de lotes FEFO (`CU-03`, `RF-002`, `RF-003`) | **Must** | **Vital para reducir mermas del 8 %–10 %.** Garantiza que bodega despache primero los lotes aptos con vencimiento más próximo y nunca productos bloqueados o caducados. |
| **HU-04 (5 pts):** Generar rutas de entrega y asignar unidad de transporte (`CU-04`, `RF-004`, `RN-01.1`) | **Must** | **Núcleo operativo de distribución.** Secuencia las paradas priorizando la cadena de frío de perecederos (carne, morcilla, longaniza) y aplicando la excepción acordada en WinWin para ventanas horarias obligatorias de manteca (`07:00–08:00 a. m.`). |
| **HU-05 (8 pts):** Registrar entrega en campo, aceptar/rechazar y sincronizar offline (`CU-01`, `CU-06`, `CU-07`, `RF-005`) | **Must** | **Indispensable para operar en campo (R-2).** Más del 30 % de las rutas rurales (veredas Runta y El Espino) carecen de señal móvil; sin captura offline con firma/foto y sincronización automática, los transportadores no pueden cerrar entregas. |
| **HU-02 (5 pts):** Generar orden comercial con ítems y condiciones especiales (`CU-02`, `CU-12`, `RF-002`) | **Should** | **Tiene procedimiento alterno viable para el lanzamiento.** Los pedidos B2B pueden seguir ingresándose mediante el flujo estándar de despacho en planta mientras se cierra la regla de autorización de condiciones comerciales especiales (`DS-02` / `CU-12`). |
| **HU-06 (5 pts):** Alertar semáforo de vencimiento y notificar advertencias (`CU-06`, `CU-19`, `RF-002`, `RF-003`) | **Should** | **Procedimiento alterno viable mediante consulta directa FEFO.** Aunque automatiza la alerta preventiva, Bodega y Calidad ya visualizan las fechas de vencimiento ordenadas en la selección FEFO (`HU-03`) y pueden revisar diariamente la bandeja de lotes sin bloquear el lanzamiento. |
| **HU-07 (5 pts):** Generar reporte de trazabilidad INVIMA por lote(s) (`CU-06`, `CU-13`, `RF-001`, `RF-006`) | **Should** | **Consulta en pantalla operativa; exportación oficial en ajuste.** Mientras Calidad confirma la plantilla exacta PDF/Excel exigida en auditoría (`DS-07`), el personal puede consultar la traza completa en pantalla y exportar CSV básico en menos de 2 minutos. |
| **HU-08 (5 pts):** Alertar desviaciones térmicas en cadena de frío durante el transporte (`CU-02`, `RF-001.3`, `RF-003`) | **Should** | **Complementa la validación bloqueante de recepción.** Dado que en Fase 1 no hay sensores IoT en vehículos (`F2-01`), el control térmico se cubre en recepción (`HU-01`) y carga manual en patio; las alertas automáticas en ruta entran si queda capacidad en el sprint. |
| **HU-09 / PD-01 (3 pts):** Impresión directa de etiquetas de código de barras desde báscula de bodega | **Could** | **Contingencia / conveniencia operativa.** Ahorra tiempo de digitación en báscula, pero el auxiliar puede digitar el código de lote manualmente (`PD-01`) sin afectar la integridad ni la trazabilidad de la v1.0. |
| **HU-10 / PR-03 (2 pts):** Resumen previo de saldo disponible válido (kg) junto al selector de pedido (`P-05`) | **Could** | **Mejora de experiencia de usuario (hallazgo heurístico PR-03).** Facilita al asesor comercial ver el stock antes de pulsar reservar, pero la validación al guardar ya protege contra sobreventa. |
| **F2-01 (13 pts):** Monitoreo telemétrico con sensores IoT de temperatura en tiempo real en vehículos | **Won't** | **Fuera de alcance y presupuesto Fase 1 (R-4).** Requiere compra e instalación de hardware en flota vehicular, excediendo el tope de \$20M COP; se mantiene verificación manual del cajón frío en patio. |
| **F2-02 (13 pts):** Facturación electrónica nativa integrada directamente con la DIAN | **Won't** | **Exclusión explícita del alcance (X3).** La Tradición ya cuenta con software contable; SICIRD exportará reportes de entregas conciliadas hacia dicho sistema. |
| **F2-03 (8 pts):** Rastreo GPS en vivo del vehículo y portal web de autogestión para clientes B2B | **Won't** | **Fuera de alcance Fase 1 (X1 / X4).** El modelo comercial B2B opera por preventa y ventanas horarias acordadas; abrir acceso externo a clientes eleva costos de infraestructura y soporte. |
| **PR-08 (5 pts):** Conexión Bluetooth automática entre báscula del camión y dispositivo móvil del transportador | **Won't** | **Descartado para v1.0.** Inviable por heterogeneidad de básculas en vehículos y presupuesto acotado; se mantiene el ingreso manual precargado en `P-02`. |

---

### 2\. Verificación del límite de esfuerzo

*Nota metodológica:* Los ítems clasificados en **Won't** (39 puntos en total) están fuera del alcance de la v1.0 y **no consumen esfuerzo** de esta entrega. El esfuerzo planificado de la entrega v1.0 asciende a **54 puntos de historia** distribuidos entre *Must*, *Should* y *Could*:

| Categoría | Requisitos incluidos | Puntos | % del esfuerzo |
| :---- | :---- | :---: | :---: |
| **Must** | `HU-01` (8), `HU-03` (8), `HU-04` (5), `HU-05` (8) | **29 pts** | **53,7 %** |
| **Should** | `HU-02` (5), `HU-06` (5), `HU-07` (5), `HU-08` (5) | **20 pts** | **37,0 %** |
| **Could** | `HU-09 / PD-01` (3), `HU-10 / PR-03` (2) | **5 pts** | **9,3 %** |
| **Won't** | `F2-01` (13), `F2-02` (13), `F2-03` (8), `PR-08` (5) *(no consumen esfuerzo de esta entrega)* | *(39 pts)* | **0,0 %** |
| **TOTAL ENTREGA v1.0** | **10 requisitos activos (HU-01 a HU-10)** | **54 pts** | **100,0 %** |

**¿Qué se movió de categoría para cumplir el límite, y con qué argumento?** En la estimación inicial de la Sesión 3, 7 de las 8 historias (`HU-01` a `HU-07`) estaban etiquetadas como *Must*, sumando **44 de 49 puntos (89,8 %)**, lo cual violaba el límite máximo recomendado del 60 % y dejaba al proyecto sin margen ante imprevistos técnicos (especialmente en la sincronización offline). Para alcanzar un **53,7 % en Must**, se reclasificaron **HU-02 (5 pts), HU-06 (5 pts) y HU-07 (5 pts)** de *Must* a **Should** con los siguientes argumentos operativos:

1. **HU-02 (Orden comercial con condiciones):** Aún tiene pendiente la definición de reglas de aprobación comercial (`DS-02`, fecha 30/11/2026) y cuenta con el flujo alterno de toma de pedidos estándar en planta.  
2. **HU-06 (Alertas automáticas de semáforo):** El control preventivo ya queda garantizado en el núcleo FEFO de `HU-03` (que ordena por vencimiento y bloquea caducados); las notificaciones automáticas diarias (`CU-08`) tienen procedimiento alterno mediante revisión visual en bandeja de bodega.  
3. **HU-07 (Reporte INVIMA exportable):** La trazabilidad queda almacenada íntegramente desde `HU-01`, `HU-03` y `HU-05`; la plantilla oficial de exportación PDF/Excel sigue pendiente de validación con Calidad (`DS-07`, fecha 30/11/2026), por lo que puede entregarse en la segunda mitad de la iteración sin frenar el lanzamiento del núcleo operativo.

---

### 3\. Won't de esta entrega

| Requisito | Razón | Fecha de revisión |
| :---- | :---- | :---- |
| **F2-01:** Sensores IoT de temperatura en tiempo real dentro de los vehículos | Excede el presupuesto aprobado para Fase 1 ($15M–$20M COP) al requerir adquisición, calibración e integración de hardware telemétrico en la flota. Se cubre temporalmente con verificación térmica manual en patio de carga. | **15 de abril de 2027** (Comité de evaluación post-lanzamiento Fase 1 / inicio Fase 2\) |
| **F2-02:** Facturación electrónica nativa integrada directamente ante la DIAN | Duplica funcionalidades ya cubiertas por el software contable actual de La Tradición (exclusión `X3`). SICIRD entregará archivos de conciliación de entregas efectivas para su cargue contable. | **15 de abril de 2027** (Revisión de arquitectura e integraciones Fase 2\) |
| **F2-03:** Rastreo GPS en tiempo real del camión y portal B2B de autogestión para clientes | Aumenta significativamente los costos de servidores, mapas en vivo y soporte a usuarios externos sin ser crítico para resolver las mermas ni los retrasos operativos internos. | **01 de mayo de 2027** (Evaluación comercial de expansión B2B) |
| **PR-08:** Integración Bluetooth entre báscula del vehículo y teléfono móvil del transportador | Los vehículos actuales cuentan con básculas heterogéneas sin conectividad estándar; implementar drivers específicos compromete el cronograma Q1 2027\. | **15 de abril de 2027** (Revisión de mejoras operativas de campo) |

---

### 4\. Confirmación del patrocinador

| Campo | Detalle |
| :---- | :---- |
| **Nombre y cargo de quien confirma la lista de Must** | **Julián Martínez** — Gerente General, La Tradición (Patrocinador del Proyecto SICIRD) |
| **Fecha de confirmación** | **31 de octubre de 2026** *(Taller de validación de alcance y cierre de parámetros en Planta Barrio Libertador, Tunja)* |

---

> **Control de configuración en repositorio:** Este documento se almacena en `04-priorizacion/backlog-moscow.md` mediante Pull Request, con al menos un commit propio de cada integrante del equipo (`RicardoForero`, `Git-kriner2005`, `diegocholo-bli` y Yisel Matabajoy) y revisión cruzada aprobada antes de fusionar a la rama principal.
