#!/usr/bin/env bash

# Force REPO variable to avoid 404s
export REPO="community-scripts/ProxmoxVE"

# Source build functions
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)

APP="Profilarr"
var_tags="${var_tags:-arr}"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-512}"
var_disk="${var_disk:-2}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
    header_info
    check_container_storage
    check_container_resources
    if [[ ! -f /root/.config/profilarr/profilarr.yml ]]; then
        msg_error "No ${APP} Installation Found!"
        exit
    fi

    msg_info "Updating ${APP}"
    curl -fsSL "$(curl -fsSL https://api.github.com/repos/Dictionarry-Hub/profilarr/releases/latest | grep download | grep linux-x64 | cut -d\" -f4)" -o $(basename "$(curl -fsSL https://api.github.com/repos/Dictionarry-Hub/profilarr/releases/latest | grep download | grep linux-x64 | cut -d\" -f4)")
    tar -C /usr/local/bin -xJf profilarr*.tar.xz
    rm -rf profilarr*.tar.xz
    msg_ok "Updated ${APP}"

    msg_ok "Updated Successfully"
    exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following IP:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}${IP}${CL}"
