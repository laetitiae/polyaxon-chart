{{/*
Volume mounts
*/}}
{{- define "volumes.volumeMounts.upload" }}
{{- if .Values.persistence.upload }}
- mountPath: {{ .Values.persistence.upload.mountPath | quote }}
  name: upload
  {{ if .Values.persistence.upload.subPath -}}
  subPath: {{ .Values.persistence.upload.subPath | quote }}
  {{- end }}
{{- else if .Values.nfsProvisioner.enabled }}
- mountPath: {{ .Values.nfsProvisioner.pvc.upload.mountPath | quote }}
  name: upload
{{- end }}
{{- end -}}
{{- define "volumes.volumeMounts.logs" }}
{{- if .Values.persistence.logs }}
- mountPath: {{ .Values.persistence.logs.mountPath | quote }}
  name: logs
  {{ if .Values.persistence.logs.subPath -}}
  subPath: {{ .Values.persistence.logs.subPath | quote }}
  {{- end }}
{{- else if .Values.nfsProvisioner.enabled }}
- mountPath: {{ .Values.nfsProvisioner.pvc.logs.mountPath | quote }}
  name: logs
{{- end }}
{{- end -}}
{{- define "volumes.volumeMounts.repos" }}
{{- if .Values.persistence.repos }}
- mountPath: {{ .Values.persistence.repos.mountPath | quote }}
  name: repos
  {{ if .Values.persistence.repos.subPath -}}
  subPath: {{ .Values.persistence.repos.subPath | quote }}
  {{- end }}
{{- else if .Values.nfsProvisioner.enabled }}
- mountPath: {{ .Values.nfsProvisioner.pvc.repos.mountPath | quote }}
  name: repos
{{- end }}
{{- end -}}
{{- define "volumes.volumeMounts.data" }}
{{- if .Values.persistence.data }}
{{- range $key, $val := .Values.persistence.data }}
- mountPath: {{ $val.mountPath | quote }}
  name: {{ $key }}
  {{ if $val.subPath -}}
  subPath: {{ $val.subPath | quote }}
  {{- end }}
{{- end}}
{{- else if .Values.nfsProvisioner.enabled }}
- mountPath: {{ .Values.nfsProvisioner.pvc.data.mountPath | quote }}
  name: data
{{- else }}
- mountPath: {{ .Values.defaultPersistence.data.data.mountPath | quote }}
  name: data
{{- end }}
{{- end -}}
{{- define "volumes.volumeMounts.outputs" }}
{{- if .Values.persistence.outputs }}
{{- range $key, $val := .Values.persistence.outputs }}
- mountPath: {{ $val.mountPath | quote }}
  name: {{ $key }}
  {{ if $val.subPath -}}
  subPath: {{ $val.subPath | quote }}
  {{- end }}
{{- end}}
{{- else if .Values.nfsProvisioner.enabled }}
- mountPath: {{ .Values.nfsProvisioner.pvc.outputs.mountPath | quote }}
  name: outputs
{{- else }}
- mountPath: {{ .Values.defaultPersistence.outputs.outputs.mountPath | quote }}
  name: outputs
{{- end }}
{{- end -}}

{{/*
Volumes
*/}}
{{- define "volumes.volumes.upload" }}
- name: upload
{{- if .Values.persistence.upload }}
{{- if .Values.persistence.upload.existingClaim }}
  persistentVolumeClaim:
    claimName: {{ .Values.persistence.upload.existingClaim | quote}}
{{- else }}
  hostPath:
    path:  {{ .Values.persistence.upload.hostPath | default .Values.persistence.upload.mountPath | quote }}
{{- end }}
{{- else if .Values.nfsProvisioner.enabled }}
  persistentVolumeClaim:
    claimName: {{ .Values.nfsProvisioner.pvc.upload.name | quote}}
{{- end }}
{{- end -}}
{{- define "volumes.volumes.repos" }}
- name: repos
{{- if .Values.persistence.repos }}
{{- if .Values.persistence.repos.existingClaim }}
  persistentVolumeClaim:
    claimName: {{ .Values.persistence.repos.existingClaim | quote }}
{{- else }}
  hostPath:
    path: {{ .Values.persistence.repos.hostPath | default .Values.persistence.repos.mountPath | quote }}
{{- end }}
{{- else if .Values.nfsProvisioner.enabled }}
  persistentVolumeClaim:
    claimName: {{ .Values.nfsProvisioner.pvc.repos.name | quote }}
{{- end }}
{{- end -}}
{{- define "volumes.volumes.logs" }}
- name: logs
{{- if .Values.persistence.logs }}
{{- if .Values.persistence.logs.existingClaim }}
  persistentVolumeClaim:
    claimName: {{ .Values.persistence.logs.existingClaim | quote }}
{{- else }}
  hostPath:
    path: {{ .Values.persistence.logs.hostPath | default .Values.persistence.logs.mountPath | quote }}
{{- end }}
{{- else if .Values.nfsProvisioner.enabled }}
  persistentVolumeClaim:
    claimName: {{ .Values.nfsProvisioner.pvc.logs.name | quote }}
{{- end }}
{{- end -}}
{{- define "volumes.volumes.data" }}
{{- if .Values.persistence.data }}
{{- range $key, $val := .Values.persistence.data }}
- name: {{ $key }}
{{- if $val.existingClaim }}
  persistentVolumeClaim:
    claimName: {{ $val.existingClaim }}
{{- else }}
  hostPath:
    path: {{ $val.hostPath | default $val.mountPath | quote }}
{{- end }}
{{- end}}
{{- else if .Values.nfsProvisioner.enabled }}
- name: data
  persistentVolumeClaim:
    claimName: {{ .Values.nfsProvisioner.pvc.data.name | quote }}
{{- else }}
- name: data
  hostPath:
    path: {{ .Values.defaultPersistence.data.data.hostPath | quote }}
{{- end }}
{{- end -}}
{{- define "volumes.volumes.outputs" }}
{{- if .Values.persistence.outputs }}
{{- range $key, $val := .Values.persistence.outputs }}
- name: {{ $key }}
{{- if $val.existingClaim }}
  persistentVolumeClaim:
    claimName: {{ $val.existingClaim }}
{{- else }}
  hostPath:
    path: {{ $val.hostPath | default $val.mountPath | quote }}
{{- end }}
{{- end}}
{{- else if .Values.nfsProvisioner.enabled }}
- name: outputs
  persistentVolumeClaim:
    claimName: {{ .Values.nfsProvisioner.pvc.outputs.name | quote }}
{{- else }}
- name: outputs
  hostPath:
    path: {{ .Values.defaultPersistence.outputs.outputs.hostPath | quote }}
{{- end }}
{{- end -}}


{{/*
Dirs
*/}}
{{- define "volumes.dirs" }}
- name: docker
  hostPath:
    path: {{ .Values.dirs.docker | quote }}
{{- if and .Values.dirs.nvidia.lib .Values.dirs.nvidia.bin .Values.dirs.nvidia.libcuda }}
- name: nvidia-lib
  hostPath:
    path: {{ .Values.dirs.nvidia.lib | quote }}
- name: nvidia-bin
  hostPath:
    path: {{ .Values.dirs.nvidia.bin | quote }}
- name: nvidia-libcuda
  hostPath:
    path: {{ .Values.dirs.nvidia.libcuda | quote }}
{{- end }}
{{- end -}}


{{/*
Dir mounts
*/}}
{{- define "volumes.dirMounts" }}
- name: docker
  mountPath: {{ .Values.mountPaths.docker }}
{{- if and .Values.dirs.nvidia.lib .Values.dirs.nvidia.bin .Values.dirs.nvidia.libcuda }}
- name: nvidia-lib
{{- if .Values.mountPaths.nvidia.lib }}
  mountPath: {{ .Values.mountPaths.nvidia.lib | quote }}
{{- else }}
  mountPath: {{ .Values.dirs.nvidia.lib | quote }}
{{- end }}
- name: nvidia-bin
{{- if .Values.mountPaths.nvidia.bin }}
  mountPath: {{ .Values.mountPaths.nvidia.bin | quote }}
{{- else }}
  mountPath: {{ .Values.dirs.nvidia.bin | quote }}
{{- end }}
- name: nvidia-libcuda
{{- if .Values.mountPaths.nvidia.libcuda }}
  mountPath: {{ .Values.mountPaths.nvidia.libcuda | quote }}
{{- else }}
  mountPath: {{ .Values.dirs.nvidia.libcuda | quote }}
{{- end }}
{{- end }}
{{- end -}}
