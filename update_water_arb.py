import json
import os

en_file = 'lib/l10n/app_en.arb'
es_file = 'lib/l10n/app_es.arb'

with open(en_file, 'r', encoding='utf-8') as f:
    en_data = json.load(f)
with open(es_file, 'r', encoding='utf-8') as f:
    es_data = json.load(f)

# English updates
en_data["waterStatusMaintenanceTitle"] = "Maintenance Reported"
en_data["waterStatusMaintenanceBody"] = "Maintenance has been reported in the water network. The external service is temporarily interrupted."
en_data["waterStatusActiveTitle"] = "Active Supply"
en_data["waterStatusActiveBody"] = "According to the municipal calendar, the water supply is active today. We invite you to use it responsibly."
en_data["waterStatusInactiveTitle"] = "No Scheduled Supply"
en_data["waterStatusInactiveBody"] = "According to the municipal calendar, there is no water supply scheduled in the area today. We suggest you manage your reserves."
en_data["understood"] = "Got it"

# Spanish updates
es_data["waterStatusMaintenanceTitle"] = "Mantenimiento Reportado"
es_data["waterStatusMaintenanceBody"] = "Se ha reportado mantenimiento en la red de agua. El servicio externo se encuentra temporalmente interrumpido."
es_data["waterStatusActiveTitle"] = "Suministro Activo"
es_data["waterStatusActiveBody"] = "De acuerdo al calendario municipal, el suministro de agua se encuentra activo el día de hoy. Le invitamos a hacer un uso responsable."
es_data["waterStatusInactiveTitle"] = "Sin Suministro Programado"
es_data["waterStatusInactiveBody"] = "De acuerdo al calendario municipal, hoy no hay suministro de agua programado en la zona. Le sugerimos administrar sus reservas."
es_data["understood"] = "Entendido"

with open(en_file, 'w', encoding='utf-8') as f:
    json.dump(en_data, f, indent=2, ensure_ascii=False)
with open(es_file, 'w', encoding='utf-8') as f:
    json.dump(es_data, f, indent=2, ensure_ascii=False)

print("Updated arb files.")
