{{/* vim: set filetype=mustache: */}}

{{- define "package.namespace" -}}
{{- default .Release.Namespace .Values.package.namespace | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "package.name" -}}
{{- default .Chart.Name .Values.package.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "package.fullname" -}}
{{- if .Values.package.fullname -}}
{{- .Values.package.fullname | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.package.name -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

