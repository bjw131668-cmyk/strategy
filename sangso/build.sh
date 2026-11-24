#!/bin/bash
# page.html(원본)로 PC용 index.html을 만듭니다. 내용은 page.html만 고치고 이 스크립트를 돌리세요.
cd "$(dirname "$0")"
{ printf '<!doctype html>\n<html lang="ko">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n'; cat page.html; printf '\n</html>\n'; } > index.html
