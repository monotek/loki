{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "loki-stack.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "loki-stack.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "loki-stack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "loki-stack.labels" -}}
chart: {{ template "loki-stack.chart" . }}
heritage: {{ .Release.Service }}
{{ include "loki-stack.selectorLabels" . }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "loki-stack.selectorLabels" -}}
app: {{ template "loki-stack.name" . }}
release: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "loki-stack.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "loki-stack.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Override the naming defined by the prometheus chart.
Added as a fix for https://github.com/grafana/loki/issues/1169
*/}}
{{- define "prometheus.fullname" -}}
{{- printf "%s-%s" .Release.Name "prometheus-server" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The service name to connect to Loki. Defaults to the same logic as "loki.fullname"
*/}}
{{- define "loki.serviceName" -}}
{{- if .Values.loki.serviceName -}}
{{- .Values.loki.serviceName -}}
{{- else if .Values.loki.fullnameOverride -}}
{{- .Values.loki.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "loki" .Values.loki.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}
