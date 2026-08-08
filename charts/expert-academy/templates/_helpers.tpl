{{/*
Expand the name of the chart.
*/}}
{{- define "expert-academy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to
this (by the DNS naming spec). If release name contains chart name it will
be used as a full name.
*/}}
{{- define "expert-academy.fullname" -}}
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
{{- define "expert-academy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "expert-academy.labels" -}}
helm.sh/chart: {{ include "expert-academy.chart" . }}
{{ include "expert-academy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels — the ONE app pod (api + web). No OpenClaw, no n8n
(biz.md section 6): there is no third or fourth container to select
separately.
*/}}
{{- define "expert-academy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "expert-academy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "expert-academy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "expert-academy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
The instance's routable hostname, mirroring `agentos.hostname` in
charts/agentos/templates/_helpers.tpl. `ingress.host` wins when set;
otherwise it derives from `instance.*`.
*/}}
{{- define "expert-academy.hostname" -}}
{{- if .Values.ingress.host }}
{{- .Values.ingress.host }}
{{- else }}
{{- printf "%s.%s" .Values.instance.name .Values.instance.baseDomain }}
{{- end }}
{{- end }}
