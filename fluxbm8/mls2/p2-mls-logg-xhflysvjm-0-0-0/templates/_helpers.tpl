{{/*
Expand the name of the chart.
*/}}
{{- define "logging-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "logging-operator.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "logging-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "logging-operator.labels" -}}
helm.sh/chart: {{ include "logging-operator.chart" . }}
{{ include "logging-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "logging-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "logging-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "logging-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "logging-operator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
 
{{- define "printDict" -}}
{{- $dict := index . -}}
{{- range $key, $value := $dict }}
{{- if kindIs "slice" $value }}
{{ $key }}:
{{- range $value }}
- {{ . }}
{{- end }}
{{- else if kindIs "map" $value }}
{{ $key }}:
{{- range $subkey, $subvalue := $value }}
  {{- if kindIs "map" $subvalue }}
  {{ $subkey }}:
  {{- include "printDict" $subvalue | indent 2 }}
  {{- else }}  
  {{ $subkey }}: {{ $subvalue }}
  {{- end }}  
{{- end }}
{{- else if kindIs "bool" $value }}
{{ $key }}: {{ $value | quote }}
{{- else }}
{{ $key }}: {{ $value }}
{{- end }}
{{- end }}
{{- end }}

{{- define "printDictList" -}}
{{ . | toYaml | nindent 2 }}
{{- end }}