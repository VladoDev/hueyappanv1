import json

new_es = {
  "deleteContactTitle": "Eliminar Contacto"
}

new_en = {
  "deleteContactTitle": "Delete Contact"
}

def update_file(path, new_data):
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    data.update(new_data)
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

update_file('lib/l10n/app_es.arb', new_es)
update_file('lib/l10n/app_en.arb', new_en)
