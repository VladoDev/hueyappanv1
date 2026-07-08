import json

en_file = 'lib/l10n/app_en.arb'
es_file = 'lib/l10n/app_es.arb'

en_new_keys = {
  "errorLoadingInfo": "Error loading information",
  "errorGeneric": "Error: {error}",
  "@errorGeneric": { "placeholders": { "error": {} } },
  "aResident": "A resident",
  "criticalAlarm": "Critical alarm: {name} (Lot {lot})",
  "@criticalAlarm": { "placeholders": { "name": {}, "lot": {} } },
  "paymentMade": "You made a payment: {concept}",
  "@paymentMade": { "placeholders": { "concept": {} } },
  "newPaymentConcept": "New payment concept: {concept}",
  "@newPaymentConcept": { "placeholders": { "concept": {} } },
  "noRecentActivity": "No recent activity",
  "newContact": "New Contact",
  "contactAdded": "Contact added successfully",
  "addContact": "Add Contact",
  "add": "Add",
  "couldNotLaunchDialer": "Could not launch dialer",
  "conceptDeleted": "Concept deleted successfully",
  "conceptNotFound": "Concept not found",
  "toConfirm": "To confirm",
  "amountGreaterThanZero": "Amount must be greater than 0",
  "errorReportingPayment": "Error reporting payment.",
  "sendReport": "Send Report",
  "amountNotChanged": "Amount has not changed",
  "transactionRegistered": "Transaction registered successfully",
  "conceptUpdated": "Concept updated",
  "conceptCreated": "Concept created",
  "pollCreated": "Poll created successfully",
  "createPoll": "Create Poll",
  "options": "Options",
  "addOption": "Add Option",
  "noPollsAvailable": "No polls available",
  "newPoll": "New Poll",
  "neighborhoodPolls": "Neighborhood Polls",
  "revertRequests": "Revert Requests",
  "noPendingRequests": "No pending requests",
  "pollLabel": "Poll: {title}",
  "@pollLabel": { "placeholders": { "title": {} } },
  "userLabel": "User: {name}",
  "@userLabel": { "placeholders": { "name": {} } },
  "houseLotLabel": "House/Lot: {id}",
  "@houseLotLabel": { "placeholders": { "id": {} } },
  "dateLabel": "Date: {date}",
  "@dateLabel": { "placeholders": { "date": {} } },
  "reject": "Reject",
  "approve": "Approve",
  "revertRequestSent": "Revert request sent to administrator",
  "closed": "Closed",
  "alreadyVoted": "Already voted",
  "requestRevertVote": "Request to revert vote",
  "vote": "Vote",
  "pollClosedNoVote": "This poll is closed and you did not vote.",
  "updateRequired": "Update Required",
  "updateRequiredDesc": "We have released a new version with important improvements. Please update the app to continue.",
  "updateInStore": "Update in Store",
  "alreadyVotedByOther": "Someone else has already voted on this lot",
  "noConceptsCreatedYet": "No payment concepts created yet"
}

es_new_keys = {
  "errorLoadingInfo": "Error al cargar la información",
  "errorGeneric": "Error: {error}",
  "@errorGeneric": { "placeholders": { "error": {} } },
  "aResident": "Un residente",
  "criticalAlarm": "Alarma crítica: {name} (Lote {lot})",
  "@criticalAlarm": { "placeholders": { "name": {}, "lot": {} } },
  "paymentMade": "Realizaste un pago: {concept}",
  "@paymentMade": { "placeholders": { "concept": {} } },
  "newPaymentConcept": "Nuevo concepto de pago: {concept}",
  "@newPaymentConcept": { "placeholders": { "concept": {} } },
  "noRecentActivity": "No hay actividad reciente",
  "newContact": "Nuevo Contacto",
  "contactAdded": "Contacto agregado exitosamente",
  "addContact": "Añadir Contacto",
  "add": "Añadir",
  "couldNotLaunchDialer": "No se pudo abrir el marcador telefónico",
  "conceptDeleted": "Concepto eliminado con éxito",
  "conceptNotFound": "Concepto no encontrado",
  "toConfirm": "Por confirmar",
  "amountGreaterThanZero": "El monto debe ser mayor a 0",
  "errorReportingPayment": "Error al reportar el pago.",
  "sendReport": "Enviar Reporte",
  "amountNotChanged": "El monto no ha cambiado",
  "transactionRegistered": "Transacción registrada con éxito",
  "conceptUpdated": "Concepto actualizado",
  "conceptCreated": "Concepto creado",
  "pollCreated": "Votación creada exitosamente",
  "createPoll": "Crear Votación",
  "options": "Opciones",
  "addOption": "Añadir Opción",
  "noPollsAvailable": "No hay votaciones disponibles",
  "newPoll": "Nueva Votación",
  "neighborhoodPolls": "Votaciones Vecinales",
  "revertRequests": "Solicitudes de Reversión",
  "noPendingRequests": "No hay solicitudes pendientes",
  "pollLabel": "Votación: {title}",
  "@pollLabel": { "placeholders": { "title": {} } },
  "userLabel": "Usuario: {name}",
  "@userLabel": { "placeholders": { "name": {} } },
  "houseLotLabel": "Casa/Lote: {id}",
  "@houseLotLabel": { "placeholders": { "id": {} } },
  "dateLabel": "Fecha: {date}",
  "@dateLabel": { "placeholders": { "date": {} } },
  "reject": "Rechazar",
  "approve": "Aprobar",
  "revertRequestSent": "Solicitud de reversión enviada al administrador",
  "closed": "Cerrada",
  "alreadyVoted": "Ya votaste",
  "requestRevertVote": "Solicitar revertir voto",
  "vote": "Votar",
  "pollClosedNoVote": "Esta votación ha sido cerrada y no emitiste voto.",
  "updateRequired": "Actualización Requerida",
  "updateRequiredDesc": "Hemos lanzado una nueva versión con mejoras importantes. Por favor, actualiza la aplicación para continuar.",
  "updateInStore": "Actualizar en la Tienda",
  "alreadyVotedByOther": "Alguien más ya votó en este lote",
  "noConceptsCreatedYet": "No hay conceptos de pago creados aún"
}

with open(en_file, 'r', encoding='utf-8') as f:
    en_data = json.load(f)
with open(es_file, 'r', encoding='utf-8') as f:
    es_data = json.load(f)

for k, v in en_new_keys.items():
    en_data[k] = v
for k, v in es_new_keys.items():
    es_data[k] = v

with open(en_file, 'w', encoding='utf-8') as f:
    json.dump(en_data, f, indent=2, ensure_ascii=False)
with open(es_file, 'w', encoding='utf-8') as f:
    json.dump(es_data, f, indent=2, ensure_ascii=False)

print("Updated arb files.")
