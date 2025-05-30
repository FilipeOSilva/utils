#!/usr/bin/env bash
#
# ==================================================================
# Autor   : Filipe Silva
# Created : 04/05/2025
# version : 0.1 
# Licence : GNU/GPL v3.0
# ------------------------------------------------------------------
# Description : List dir with create scripts
# ------------------------------------------------------------------
# Usage:
#       $ ./lsscript.bash
# ------------------------------------------------------------------
# History:
# ==================================================================
#
# =========================== VARIABLES ============================
. 00_my-functions.bash
 
# =========================== FUNCTIONS ============================

# ============================= CODE ===============================

echo path: "$(dirname ${BASH_SOURCE[0]})/"

ls -lah "$(dirname ${BASH_SOURCE[0]})/"
