#!/bin/bash
MESSAGE="$1"
if [ -z "$MESSAGE" ]; then
  echo "❌ استخدم: ./git_push.sh \"رسالة التعديل\""
  exit 1
fi

git add .
git commit -m "$MESSAGE"
git push
