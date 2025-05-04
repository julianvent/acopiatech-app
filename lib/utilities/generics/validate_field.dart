String? validateField(String? value) =>
    (value == null || value.isEmpty) ? 'Requerido' : null;
