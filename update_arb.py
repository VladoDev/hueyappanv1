import json

new_es = {
  "navPolls": "Votaciones",
  "pollWriteResponse": "Por favor escribe tu respuesta.",
  "pollOtherOption": "Otra opción (Escribe tu propia respuesta)",
  "pollWriteResponseHint": "Escribe tu respuesta aquí...",
  "pollQuestionLabel": "Pregunta o Título",
  "pollDescriptionLabel": "Descripción (Opcional)",
  "pollOptionX": "Opción {index}",
  "@pollOptionX": {
    "placeholders": {
      "index": {}
    }
  },
  "pollAllowCustomOptions": "Permitir a los vecinos agregar sus propias opciones",
  "pollCustomOptionsDescription": "Si un vecino escribe una opción que ya existe, su voto se sumará a esa opción.",
  "nameLabel": "Nombre",
  "phoneLabel": "Teléfono",
  "categoryLabel": "Categoría",
  "statusLabel": "Estado",
  "paymentNewTotalAbonadoLabel": "Nuevo Total Abonado",
  "paymentAmountAbonadoLabel": "Monto Abonado"
}

new_en = {
  "navPolls": "Polls",
  "pollWriteResponse": "Please write your response.",
  "pollOtherOption": "Other option (Write your own response)",
  "pollWriteResponseHint": "Write your response here...",
  "pollQuestionLabel": "Question or Title",
  "pollDescriptionLabel": "Description (Optional)",
  "pollOptionX": "Option {index}",
  "@pollOptionX": {
    "placeholders": {
      "index": {}
    }
  },
  "pollAllowCustomOptions": "Allow neighbors to add custom options",
  "pollCustomOptionsDescription": "If a neighbor writes an existing option, their vote will be added to it.",
  "nameLabel": "Name",
  "phoneLabel": "Phone",
  "categoryLabel": "Category",
  "statusLabel": "Status",
  "paymentNewTotalAbonadoLabel": "New Total Paid",
  "paymentAmountAbonadoLabel": "Amount Paid"
}

def update_file(path, new_data):
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    data.update(new_data)
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

update_file('lib/l10n/app_es.arb', new_es)
update_file('lib/l10n/app_en.arb', new_en)

print("Updated ARB files.")
