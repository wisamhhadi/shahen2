from io import BytesIO

from django.http import HttpResponse
from django.views.generic.base import View
from django.views.generic.list import MultipleObjectMixin
from openpyxl import Workbook


class ExcelView(MultipleObjectMixin, View):
    output_filename = None
    worksheet_name = None

    def get_output_filename(self):
        if self.output_filename:
            return self.output_filename
        if self.model:
            return self.model._meta.model_name
        return 'excel_data'

    def get_worksheet_name(self):
        return self.worksheet_name or 'Sheet 1'

    def get(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        fields = [
            field
            for field in queryset.model._meta.fields
            if not field.many_to_many and not field.one_to_many
        ]

        workbook = Workbook()
        worksheet = workbook.active
        worksheet.title = self.get_worksheet_name()
        worksheet.append([field.name for field in fields])

        for obj in queryset:
            row = []
            for field in fields:
                value = getattr(obj, field.name)
                row.append('' if value is None else str(value))
            worksheet.append(row)

        output = BytesIO()
        workbook.save(output)
        output.seek(0)

        response = HttpResponse(
            output.getvalue(),
            content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        )
        response['Content-Disposition'] = (
            f'attachment; filename="{self.get_output_filename()}.xlsx"'
        )
        return response
