{{- define "ai-code-assistant.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "ai-code-assistant.fullname" -}}
{{ include "ai-code-assistant.name" . }}
{{- end }}
