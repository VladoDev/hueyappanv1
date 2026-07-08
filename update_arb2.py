import json

en_file = 'lib/l10n/app_en.arb'
es_file = 'lib/l10n/app_es.arb'

with open(en_file, 'r', encoding='utf-8') as f:
    en_data = json.load(f)
with open(es_file, 'r', encoding='utf-8') as f:
    es_data = json.load(f)

en_data["alreadyVotedByOther"] = "Someone else ({name}) has already voted for Lot {lot}, House {house}"
en_data["@alreadyVotedByOther"] = {
  "placeholders": {
    "name": {},
    "lot": {},
    "house": {}
  }
}

es_data["alreadyVotedByOther"] = "Alguien más ({name}) ya votó por el Lote {lot}, Casa {house}"
es_data["@alreadyVotedByOther"] = {
  "placeholders": {
    "name": {},
    "lot": {},
    "house": {}
  }
}

with open(en_file, 'w', encoding='utf-8') as f:
    json.dump(en_data, f, indent=2, ensure_ascii=False)
with open(es_file, 'w', encoding='utf-8') as f:
    json.dump(es_data, f, indent=2, ensure_ascii=False)

print("Updated arb files again.")
