#!/bin/bash
# أدوات أساسية للنظام
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

validate_app_name() {
    if [[ ! "$1" =~ ^[a-z_]+$ ]]; then
        log "خطأ: اسم التطبيق يجب أن يحتوي على أحرف صغيرة فقط وشرط سفلية"
        exit 1
    fi
}
