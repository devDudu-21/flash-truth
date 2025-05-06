#!/bin/bash

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ASCII Art
ascii_art() {
    echo -e "${GREEN}"
    echo "███████╗██╗      █████╗ ███████╗██╗  ██╗    ████████╗██████╗ ██╗   ██╗████████╗██╗  ██╗"
    echo "██╔════╝██║     ██╔══██╗██╔════╝██║  ██║    ╚══██╔══╝██╔══██╗██║   ██║╚══██╔══╝██║  ██║"
    echo "█████╗  ██║     ███████║███████╗███████║       ██║   ██████╔╝██║   ██║   ██║   ███████║"
    echo "██╔══╝  ██║     ██╔══██║╚════██║██╔══██║       ██║   ██╔══██╗██║   ██║   ██║   ██╔══██║"
    echo "██║     ███████╗██║  ██║███████║██║  ██║       ██║   ██║  ██║╚██████╔╝   ██║   ██║  ██║"
    echo "╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝       ╚═╝   ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝"
    echo -e "${NC}"
    echo "             USB Flash Drive Checker – FlashTruth"
    echo "                  by Senhor Lorde das Trevas 👑"
    echo ""
}

# Listar dispositivos montados
listar_dispositivos() {
    pontos_montagem=()
    echo -e "${YELLOW}[?] Dispositivos montados detectados:${NC}"

    for base in /media/$USER /run/media/$USER; do
        [ -d "$base" ] || continue
        for dir in "$base"/*; do
            [ -d "$dir" ] && pontos_montagem+=("$dir")
        done
    done

    if [ ${#pontos_montagem[@]} -eq 0 ]; then
        echo -e "${RED}[-] Nenhum pendrive montado encontrado.${NC}"
        exit 1
    fi

    for i in "${!pontos_montagem[@]}"; do
        echo "[$((i+1))] ${pontos_montagem[$i]}"
    done

    echo ""
    read -p "Digite o número do pendrive desejado: " escolha
    if ! [[ "$escolha" =~ ^[0-9]+$ ]] || [ "$escolha" -lt 1 ] || [ "$escolha" -gt "${#pontos_montagem[@]}" ]; then
        echo -e "${RED}[-] Escolha inválida.${NC}"
        exit 1
    fi

    caminho="${pontos_montagem[$((escolha-1))]}"
}

# Verificar informações detalhadas do dispositivo
verificar_info() {
    listar_dispositivos

    echo -e "${GREEN}[+] Analisando informações do dispositivo: $caminho${NC}"
    dev=$(df "$caminho" | tail -1 | awk '{print $1}' | sed 's/[0-9]*$//')

    echo ""
    echo -e "${YELLOW}Informações básicas:${NC}"
    lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,LABEL "$dev"

    echo ""
    echo -e "${YELLOW}Informações detalhadas via udevadm:${NC}"
    info=$(udevadm info --query=all --name="$dev")
    echo "$info" | grep -E 'ID_MODEL|ID_VENDOR|ID_SERIAL|ID_USB_DRIVER|ID_SERIAL_SHORT'

    vendor=$(echo "$info" | grep ID_VENDOR= | cut -d= -f2)
    model=$(echo "$info" | grep ID_MODEL= | cut -d= -f2)
    serial=$(echo "$info" | grep ID_SERIAL= | cut -d= -f2)
    serial_short=$(echo "$info" | grep ID_SERIAL_SHORT= | cut -d= -f2)
    fs=$(lsblk -no FSTYPE "$dev" | head -n1)
    size_gb=$(LC_NUMERIC=C lsblk -bno SIZE "$dev" | awk '{printf "%.1f", $1 / (1024^3)}')

    echo ""
    echo -e "${YELLOW}Identificação via lsusb:${NC}"
    lsusb | grep -i "$model" || echo "Dispositivo USB não identificado com precisão."

    # Calcular pontuação
    pontos=0
    [[ "$vendor" && "$vendor" != "Generic" && "$vendor" != "Unknown" ]] && ((pontos+=2))
    [[ "$model" && "$model" != "USB_DISK" && "$model" != "Mass_Storage" ]] && ((pontos+=2))
    [[ "$serial" ]] && ((pontos+=2))
    [[ "$serial_short" ]] && ((pontos+=1))
    [[ "$fs" =~ ^(vfat|exfat|ext4|ntfs|iso9660)$ ]] && ((pontos+=1))
    (( $(LC_NUMERIC=C echo "$size_gb >= 8" | bc -l) )) && ((pontos+=2))

    echo ""
    if ((pontos >= 9)); then
        cor=$GREEN
        status="🟢 Alta confiabilidade"
    elif ((pontos >= 6)); then
        cor=$YELLOW
        status="🟡 Moderada — fique atento"
    else
        cor=$RED
        status="🔴 Provável falsificação"
    fi

    echo -e "${cor}Confiabilidade: $pontos/10 $status${NC}"

    echo ""
    read -p "Pressione ENTER para voltar ao menu."
}

# Função para formatar pendrive
formatar_pendrive() {
    dev=$(df "$caminho" | tail -1 | awk '{print $1}' | sed 's/[0-9]*$//')

    echo -e "${RED}[!] ATENÇÃO: Todos os dados serão apagados!${NC}"
    read -p "Tem certeza que deseja continuar? (s/n): " confirm
    [[ "$confirm" != "s" && "$confirm" != "S" ]] && echo "Cancelado." && sleep 1 && return

    echo ""
    echo -e "${YELLOW}Escolha o sistema de arquivos:${NC}"
    echo "[1] FAT32"
    echo "[2] exFAT"
    echo "[3] ext4"
    read -p "Opção: " tipo_fs

    case "$tipo_fs" in
        1) fs_type="vfat" ;;
        2) fs_type="exfat" ;;
        3) fs_type="ext4" ;;
        *) echo -e "${RED}Opção inválida.${NC}"; return ;;
    esac

    echo -e "${GREEN}[+] Desmontando...${NC}"
    sudo umount "${dev}"* &>/dev/null

    echo -e "${GREEN}[+] Formatando ${dev} como ${fs_type}...${NC}"
    sudo mkfs."$fs_type" -F "$dev"

    echo -e "${GREEN}[+] Formatação concluída.${NC}"
    sleep 2
}

# Testar pendrive com F3
testar_pendrive() {
    sudo apt install -y f3 &>/dev/null
    listar_dispositivos

    echo -e "${YELLOW}[?] Verificando conteúdo do pendrive...${NC}"
    arquivos=$(find "$caminho" -mindepth 1 | wc -l)

    if [ "$arquivos" -gt 0 ]; then
        echo -e "${RED}[!] Conteúdo detectado (${arquivos} itens).${NC}"
        read -p "Deseja formatar o pendrive antes do teste? (s/n): " escolha
        if [[ "$escolha" == "s" || "$escolha" == "S" ]]; then
            formatar_pendrive
        fi
    fi

    echo -e "${GREEN}[+] Iniciando teste com F3 em $caminho...${NC}"
    f3write "$caminho"
    f3read "$caminho"

    echo ""
    read -p "Pressione ENTER para voltar ao menu."
}

# Menu principal
main_menu() {
    while true; do
        clear
        ascii_art
        echo -e "${YELLOW}Selecione uma opção:${NC}"
        echo "[1] Verificar informações do pendrive"
        echo "[2] Testar pendrive com F3"
        echo "[0] Sair"
        echo ""
        read -p "Opção: " opcao

        case $opcao in
            1) verificar_info ;;
            2) testar_pendrive ;;
            0) echo -e "${GREEN}Saindo...${NC}"; exit 0 ;;
            *) echo -e "${RED}Opção inválida.${NC}"; sleep 1 ;;
        esac
    done
}

# Execução principal
main_menu
