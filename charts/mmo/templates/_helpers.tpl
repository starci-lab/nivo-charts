{{/* Expand the chart name. */}}
{{- define "mmo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Create a DNS-safe fully qualified application name. */}}
{{- define "mmo.fullname" -}}
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

{{/* Chart label value. */}}
{{- define "mmo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Common labels. */}}
{{- define "mmo.labels" -}}
helm.sh/chart: {{ include "mmo.chart" . }}
{{ include "mmo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Stable selector labels. */}}
{{- define "mmo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mmo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Service account name. */}}
{{- define "mmo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mmo.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Required image reference. */}}
{{- define "mmo.image" -}}
{{- $repository := required "image.repository is required" .Values.image.repository -}}
{{- $tag := required "image.tag is required" .Values.image.tag -}}
{{- printf "%s:%s" $repository $tag -}}
{{- end }}

{{/* PVC name, either supplied or created by this release. */}}
{{- define "mmo.persistenceClaimName" -}}
{{- default (include "mmo.fullname" .) .Values.persistence.existingClaim -}}
{{- end }}
