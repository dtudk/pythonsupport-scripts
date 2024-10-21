#!/bin/zsh

code_path=$(which code 2>/dev/null)
code_extensions=("ms-python.python" "ms-toolsai.jupyter")

check_vsCode() {
    source /tmp/healthCheckResults

    healthCheckResults[code,installed]="$([ -d "$code_path" ] && echo false || echo true)"
    healthCheckResults[code,path]=$code_path
    healthCheckResults[code,version]=$($code_path --version 2>/dev/null | head -n 1)

    save_healthCheckResults

    for extension in "${(k)code_extensions[@]}"; do
        version=$(code --list-extensions --show-versions 2>/dev/null | grep "${extension}" | cut -d "@" -f 2)
        installed="$([ -z "$version" ] && echo false || echo true)"

        healthCheckResults[${extension},version]=$version
        healthCheckResults[${extension},installed]=$installed
        save_healthCheckResults
    done

    
}