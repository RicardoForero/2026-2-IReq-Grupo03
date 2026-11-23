# language: es
Característica: Control de Inventarios, Rutas y Distribución Sanitaria (SRS-SICIRD-001 v1.0)
  Como organización de distribución alimentaria (La Tradición)
  Quiero garantizar la trazabilidad sanitaria, la rotación FEFO, el control térmico y la entrega confiable en ruta
  Para cumplir la normativa INVIMA y evitar pérdidas por vencimiento o rupturas de cadena de frío.

  Antecedentes:
    Dado que el sistema SICIRD tiene cargada la línea base "LB-1.0"
    Y existen usuarios autenticados con roles válidos en la matriz de permisos

  @AC-01 @RF-001.1 @RN-01 @P-04 @CP-001
  Escenario: AC-01 Ingreso exitoso de lote refrigerado con registro INVIMA vigente
    Dado que el Auxiliar de Recepción está en la pantalla "P-04"
    Y el proveedor "Lácteos del Valle S.A.S." cuenta con registro sanitario "INVIMA-2024M-0019821" vigente hasta "2028-06-30"
    Cuando registra el producto "Queso Campesino 500g" con peso "120.0" kg, temperatura "2.5" °C y vencimiento "2026-12-20"
    Entonces el sistema genera un código único de lote inmutable
    Y clasifica el lote en estado "Apto"
    Y muestra el mensaje "M-01" indicando registro correcto con trazabilidad inicial

  @AC-02 @RF-001.1 @RN-01 @P-04 @CP-001
  Escenario: AC-02 Bloqueo de ingreso por registro sanitario INVIMA vencido o inválido
    Dado que el Auxiliar de Recepción está en la pantalla "P-04"
    Y el código sanitario ingresado es "INVIMA-2019M-0001122" con vigencia expirada
    Cuando intenta guardar el ingreso del lote
    Entonces el sistema rechaza la operación sin crear el lote
    Y muestra el mensaje de error "M-02"

  @AC-03 @RF-001.2 @RN-02 @P-04 @CP-001
  Escenario: AC-03 Aceptación de lote congelado dentro de rango térmico permitido
    Dado que el Auxiliar de Recepción registra un producto de familia "Congelados" en "P-04"
    Cuando ingresa una temperatura verificada de "-19.2" °C
    Entonces el sistema valida el cumplimiento del rango térmico menor o igual a -18.0 °C
    Y permite continuar el alta del lote en estado "Apto"

  @AC-04 @RF-001.2 @RN-02 @P-04 @CP-002
  Escenario: AC-04 Ingreso a cuarentena automática por desviación moderada de temperatura
    Dado que el Auxiliar de Recepción registra un producto de familia "Refrigerados" en "P-04"
    Cuando ingresa una temperatura medida de "6.8" °C fuera del rango de 0 °C a 4 °C
    Entonces el sistema asigna automáticamente el estado sanitario "Cuarentena"
    Y bloquea el lote para cualquier alistamiento o despacho
    Y muestra la alerta "M-03"

  @AC-05 @RF-003.1 @RN-03 @P-07 @CP-005
  Escenario: AC-05 Clasificación inicial en semáforo según días remanentes al ingreso
    Dado que la fecha del sistema es "2026-11-22"
    Cuando ingresa un lote apto con fecha de vencimiento "2026-12-04" (12 días remanentes)
    Entonces el sistema asigna el indicador de semáforo "Amarillo" en "P-07"
    Y muestra el aviso informativo "M-05"

  @AC-06 @RF-002.1 @RN-06 @P-05 @CP-003
  Escenario: AC-06 Asignación automática FEFO seleccionando el lote apto más próximo a vencer
    Dado que existen tres lotes aptos del producto "Yogurt Natural 1000ml":
      | codigo_lote | stock_unidades | fecha_vencimiento | estado |
      | LOT-2026-01 | 50             | 2026-12-18        | Apto   |
      | LOT-2026-02 | 80             | 2026-12-05        | Apto   |
      | LOT-2026-03 | 60             | 2026-12-12        | Apto   |
    Cuando el Coordinador de Logística solicita alistar "70" unidades en "P-05"
    Entonces el sistema asigna primero "70" unidades del lote "LOT-2026-02"
    Y emite la confirmación "M-10"

  @AC-07 @RF-002.1 @RN-04 @RN-06 @P-05 @CP-003
  Escenario: AC-07 Exclusión de lotes vencidos o en cuarentena durante el cálculo FEFO
    Dado que el lote "LOT-2026-00" vence el "2026-11-25" pero está en estado "Cuarentena"
    Y el lote "LOT-2026-04" vence el "2026-12-10" y está en estado "Apto"
    Cuando se ejecuta la asignación automática FEFO en "P-05"
    Entonces el sistema omite el lote "LOT-2026-00"
    Y asigna el pedido al lote "LOT-2026-04"

  @AC-08 @RF-002.2 @RN-07 @SC-01 @P-06 @CP-004
  Escenario: AC-08 Excepción FEFO aprobada por Jefe de Bodega con motivo cerrado y auditoría
    Dado que un usuario autenticado con rol "Jefe de Bodega" (PER-02b) abre el modal "P-06"
    Cuando selecciona un lote alternativo apto para atender requerimiento institucional de vida útil mínima
    Y elige el motivo de catálogo cerrado "Exigencia contractual de vida útil mínima del cliente" con justificación de 35 caracteres
    Entonces el sistema autoriza el cambio de lote
    Y registra el evento inmutable en bitácora con usuario, timestamp y lotes involucrados
    Y muestra la alerta de auditoría "M-13"

  @AC-09 @RF-002.2 @RN-07 @RNF-002 @SC-01 @P-06 @CP-012
  Escenario: AC-09 Rechazo de excepción FEFO intentada por rol distinto al Jefe de Bodega
    Dado que un usuario con rol "Auxiliar de Bodega" intenta modificar el lote sugerido por FEFO en "P-06"
    Cuando solicita confirmar la excepción
    Entonces el sistema bloquea la acción por falta de privilegios RBAC
    Y muestra el mensaje de error "M-12"

  @AC-10 @RF-003.1 @RN-03 @RN-12 @P-07 @CP-005
  Escenario: AC-10 Transición automática de semáforo Verde a Amarillo y Rojo en proceso diario
    Dado que un lote apto tiene 6 días remanentes de vida útil en estado "Amarillo"
    Cuando se ejecuta la tarea programada diaria a las "00:05" COT
    Entonces el sistema recalcula los días remanentes a 5 días
    Y cambia el semáforo del lote a "Rojo" en "P-07"
    Y genera la alerta prioritaria "M-06"

  @AC-11 @RF-003.2 @RN-04 @P-07 @CP-005
  Escenario: AC-11 Bloqueo inmediato de despacho al alcanzar fecha de vencimiento
    Dado que un lote en bodega alcanza 0 días remanentes de vida útil
    Cuando el proceso diario actualiza su estado a "Vencido"
    Entonces el sistema bloquea toda salida o asignación del lote
    Y si alguien intenta despacharlo muestra el error "M-07"

  @AC-12 @RF-003.2 @RN-05 @RN-14 @P-07 @CP-005
  Escenario: AC-12 Liberación de cuarentena exclusivamente por Coordinador de Calidad
    Dado que el lote "LOT-2026-09" se encuentra en estado "Cuarentena" en "P-07"
    Cuando el usuario con rol "Coordinador de Calidad" registra el dictamen técnico favorable firmado
    Entonces el lote cambia a estado "Apto"
    Y se conserva la traza inmutable del dictamen con el mensaje "M-09"

  @AC-13 @RF-004.1 @RN-09 @P-08 @DE-01
  Escenario: AC-13 Agrupación y secuenciación de entregas por ruta asignada
    Dado que existen 5 pedidos alistados para la ruta "Tunja Centro - Norte" en "P-08"
    Cuando el Encargado de Despacho asigna el vehículo de placa "WXY-456" y genera la hoja de ruta
    Entonces el sistema ordena las paradas secuencialmente y vincula los lotes asignados a cada pedido

  @AC-14 @RF-004.2 @RN-09 @P-08 @CP-006
  Escenario: AC-14 Aprobación de despacho dentro del 100 % de capacidad nominal en kg y m3
    Dado que el vehículo "WXY-456" tiene capacidad nominal de "1500" kg y "8.0" m3
    Cuando se cargan pedidos que suman "1420" kg (94.7 %) y "7.2" m3 (90.0 %) en "P-08"
    Entonces el sistema habilita la confirmación de salida de ruta sin restricciones

  @AC-15 @RF-004.2 @RN-09 @P-08 @CP-006
  Escenario: AC-15 Bloqueo de despacho al superar peso o volumen nominal del vehículo
    Dado que el vehículo "WXY-456" tiene capacidad nominal de "1500" kg
    Cuando se intenta agregar un pedido que lleva la carga total a "1560" kg (104.0 %) en "P-08"
    Entonces el sistema impide confirmar el despacho
    Y muestra el mensaje de error "M-14"

  @AC-16 @RF-005.1 @RN-10 @P-01 @P-02 @CP-007
  Escenario: AC-16 Registro en línea de entrega total con firma digital y descuento de inventario
    Dado que el Conductor tiene conectividad móvil activa en "P-02"
    Cuando registra la entrega del 100 % de unidades del pedido "PED-8801" con firma del receptor
    Entonces el sistema actualiza el estado del pedido a "Entregado" y registra la marca de tiempo UTC

  @AC-17 @RF-005.1 @RNF-003 @RN-10 @P-01 @P-02 @CP-007
  Escenario: AC-17 Captura offline de entrega parcial en zona sin cobertura con cifrado local
    Dado que el dispositivo móvil del Conductor pierde conexión a internet en ruta rural
    Cuando registra una entrega parcial de 18 de 20 unidades en "P-02" con evidencia capturada
    Entonces el sistema almacena la transacción en la cola local cifrada con AES-256
    Y muestra el mensaje informativo "M-15"

  @AC-18 @RF-005.2 @RN-11 @P-03 @CP-008
  Escenario: AC-18 Registro de rechazo parcial en punto de venta y marcación preventiva de retorno
    Dado que el cliente rechaza 2 unidades por empaque averiado en el punto de venta
    Cuando el Conductor registra la causal de rechazo en la pantalla "P-03"
    Entonces el sistema vincula las 2 unidades al lote original bajo estado preventivo "En observación / Rechazado"

  @AC-19 @RF-006.1 @RN-15 @P-09 @CP-009
  Escenario: AC-19 Consulta de trazabilidad hacia atrás desde cliente hasta proveedor
    Dado que el Responsable de Calidad ingresa el pedido "PED-8801" o código de lote en "P-09"
    Cuando ejecuta la búsqueda de trazabilidad inversa
    Entonces el sistema despliega el proveedor de origen, registro sanitario INVIMA, temperatura de ingreso y ruta de entrega

  @AC-20 @RF-006.1 @RNF-001 @RN-15 @P-09 @CP-009
  Escenario: AC-20 Consulta de trazabilidad hacia adelante por lote en menos de 2 minutos
    Dado que se requiere rastrear la distribución completa del lote "LOT-2026-02" en "P-09"
    Cuando el Responsable de Calidad inicia la consulta de impacto por lote
    Entonces el sistema lista todos los clientes y pedidos receptores en menos de 120 segundos

  @AC-21 @RF-006.1 @RNF-002 @RNF-004 @RN-14 @P-09 @CP-011
  Escenario: AC-21 Verificación de inmutabilidad de eventos en historial de trazabilidad
    Dado que existe un historial de eventos registrado para el lote "LOT-2026-02"
    Cuando cualquier usuario o administrador consulta la bitácora en "P-09"
    Entonces el sistema impide editar o eliminar registros históricos (operación solo lectura / append-only)

  @AC-22 @RF-006.2 @RN-15 @P-09 @DE-02
  Escenario: AC-22 Exportación de reporte consolidado de trazabilidad para inspección INVIMA
    Dado que se ha consultado la traza completa del lote "LOT-2026-02" en "P-09"
    Cuando el Responsable de Calidad solicita generar el reporte oficial de auditoría
    Entonces el sistema exporta el documento consolidado con todos los hitos de cadena de custodia

  @AC-23 @RF-005.1 @RNF-003 @P-01 @CP-013
  Escenario: AC-23 Sincronización automática e idempotente al restablecer conexión móvil
    Dado que existen 4 transacciones pendientes en la cola local cifrada del dispositivo móvil
    Cuando el dispositivo recupera conectividad de red estable
    Entonces el sistema sincroniza las 4 transacciones con el servidor central sin duplicar registros

  @AC-24 @RF-005.2 @RN-04 @RN-11 @P-03 @P-07 @CP-008
  Escenario: AC-24 Aislamiento de unidades devueltas frente al inventario disponible para FEFO
    Dado que el retorno del pedido "PED-8801" ingresó a bodega en estado "En observación / Rechazado"
    Cuando se ejecuta un nuevo alistamiento FEFO en "P-05"
    Entonces el sistema excluye las unidades devueltas hasta que Calidad emita dictamen en "P-07"

  @AC-25 @RNF-001 @P-09 @AN-01
  Escenario: AC-25 Cumplimiento de tiempo de respuesta < 2 minutos bajo consultas concurrentes
    Dado que 5 usuarios de Calidad y Auditoría ejecutan consultas de trazabilidad simultáneas en "P-09"
    Cuando se mide el tiempo total de respuesta de cada consulta
    Entonces el 100 % de las consultas finaliza por debajo del umbral máximo de 120 segundos
