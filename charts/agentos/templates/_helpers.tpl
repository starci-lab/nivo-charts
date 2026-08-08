{{/*
Expand the name of the chart.
*/}}
{{- define "agentos.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to
this (by the DNS naming spec). If release name contains chart name it will
be used as a full name.
*/}}
{{- define "agentos.fullname" -}}
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
{{- define "agentos.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "agentos.labels" -}}
helm.sh/chart: {{ include "agentos.chart" . }}
{{ include "agentos.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels — the ONE app pod (controlplane + openclaw + n8n + mcp).
There is deliberately no per-container selector; they are one Deployment,
one Pod, one set of selector labels (biz.md section 5: they share fate).
*/}}
{{- define "agentos.selectorLabels" -}}
app.kubernetes.io/name: {{ include "agentos.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "agentos.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "agentos.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
The instance's routable hostname — biz.md section 5's "routable address per
instance" (`<name>.agentos.nivo.vn`, wildcard TLS, no per-instance ACME).
Templates that need the host (Ingress, the controlplane's own webhook /
OAuth callback config) compute it here once so the two can never drift
apart. `ingress.host` wins when set; otherwise it derives from `instance.*`.
*/}}
{{- define "agentos.hostname" -}}
{{- if .Values.ingress.host }}
{{- .Values.ingress.host }}
{{- else }}
{{- printf "%s.%s" .Values.instance.name .Values.instance.baseDomain }}
{{- end }}
{{- end }}

{{/*
The nivo-cli image reference — shared by the provision hook Job and the
backup CronJob, so both always run the SAME cli build rather than two
templates each hardcoding `image.cli` separately.
*/}}
{{- define "agentos.cliImage" -}}
{{- printf "%s:%s" .Values.image.cli.repository .Values.image.cli.tag }}
{{- end }}
