#!/bin/bash

cd $HOME

bin_folder="${HOME}/work/bin"
mkdir -p "${bin_folder}"

prompt_user() {
    local prompt_message="$1"
    local user_choice
    echo -ne "\033[0;33mINPUT REQUIRED:\033[0m ${prompt_message} (y/n): " > /dev/tty
    read -rn 1 user_choice < /dev/tty  # -n 1 reads only one character without a newline
    while [[ ! $user_choice =~ ^[YyNn]$ ]]; do
        echo -e "\n\033[0;31mERROR:\033[0m Invalid input; please enter y or n" > /dev/tty
        echo -ne "\033[0;33mINPUT REQUIRED:\033[0m ${prompt_message} (y/n): " > /dev/tty
        read -rn 1 user_choice < /dev/tty
    done
    printf '%s' "$user_choice"
}

manage_symlink() {
    local link_name="$1"
    local home_link="$HOME/$link_name"
    local bin_link="$bin_folder/$link_name"

    mkdir -p "$bin_folder/${link_name}"

    if [ -L "$home_link" ]; then
        [ "$(readlink "$home_link")" != "$bin_link" ] && rm "$home_link" && ln -s "$bin_link" "$home_link"
    elif [ -d "$home_link" ]; then
        [ "$home_link" != "$bin_link" ] && mv "$home_link" "$bin_folder" && ln -s "$bin_link" "$home_link"
    elif [ ! -e "$home_link" ]; then
        mkdir -p "$bin_link" && ln -s "$bin_link" "$home_link"
    else
        echo -e "\033[0;31mERROR:\033[0m $home_link is a file or another type. Skipping." > /dev/tty && exit 1
    fi
}

create_symlinks() {
    local links=(".config" ".celltypist" ".gsutil" ".ipython" ".java" ".jupyter" ".keras" ".local" ".ncbi" ".nv" ".nextflow" "ondemand" ".parallel")
    for link in "${links[@]}"; do
        manage_symlink "$link"
    done

    ln -sf /data/cephfs-2/unmirrored/projects/romagnani-share share
    ln -sf /data/cephfs-2/unmirrored/groups/romagnani group
    echo "" >> "${HOME}/.bashrc"
    echo "mkdir -p ~/scratch/tmp/.cache" >> "${HOME}/.bashrc"
}

install_miniforge() {
    [ -d "${bin_folder}/miniforge3/" ] && rm -rf "${bin_folder}/miniforge3/"
    [ -d "${HOME}/.conda" ] || [ -L "${HOME}/.conda" ] && rm -rf "${HOME}/.conda"

    cd ${bin_folder}
    curl -L https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -o Miniforge3-Linux-x86_64.sh > /dev/null 2>&1
    bash Miniforge3-Linux-x86_64.sh -b -p ${bin_folder}/miniforge3/ > /dev/null
    rm Miniforge3-Linux-x86_64.sh

    cat <<EOF > ${HOME}/.condarc
channels:
  - https://prefix.dev/conda-forge
  - https://prefix.dev/pytorch
  - https://prefix.dev/bioconda
show_channel_urls: true
changeps1: true
channel_priority: flexible
EOF

    source ${bin_folder}/miniforge3/etc/profile.d/conda.sh
    echo "" >> "${HOME}/.bashrc"
    sed -i '/conda activate/d; /conda source/d; /source .*\.conda\.sh/d' "${HOME}/.bashrc"
    echo "source ${bin_folder}/miniforge3/etc/profile.d/conda.sh" >> "${HOME}/.bashrc"

    [ ! -f "${HOME}/.Rprofile" ] || ! grep -q "options(download.file.method = 'wget')" "${HOME}/.Rprofile" && echo "options(download.file.method = 'wget')" >> "${HOME}/.Rprofile"

    conda upgrade --all -y > /dev/null

    mv "${HOME}/.conda" "${bin_folder}" && ln -sf "${bin_folder}/.conda" "${HOME}/.conda"

    [ -d ".cache" ] && mv .cache ~/scratch/tmp/ && ln -sf ~/scratch/tmp/.cache ~/.cache
    [ -L ".cache" ] && rm .cache && ln -sf ~/scratch/tmp/.cache ~/.cache
}

create_rstudio_env() {
    local env_file="$HOME/group/work/bin/source/R_4.3.3.yml"
    local env_name="R_4.3.3"

    if [[ $1 == "newname" ]]; then
        echo "Enter the name for the new environment:" > /dev/tty && read -r env_name < /dev/tty
        cp "$env_file" "${TMPDIR}/${env_name}.yml"
        sed -i "1s/.*/name: ${env_name}/" "${TMPDIR}/${env_name}.yml"
        env_file="${TMPDIR}/${env_name}.yml"
    fi

    conda env create -f "$env_file" > /dev/null
    ln -s ${bin_folder}/miniforge3/envs/${env_name}/lib/R/library/ R
}

create_reticulate_env() {
    conda env create -f $HOME/group/work/bin/source/r-reticulate.yml > /dev/null
}

# Modified function calls to properly capture the output
choice=$(prompt_user "Do you want to create easy access shortcuts for folders?")
if [[ "$choice" =~ ^[Yy]$ ]]; then
    echo "Creating symlinks..." > /dev/tty
    create_symlinks
fi

choice=$(prompt_user "Do you want to install Miniforge3?")
if [[ "$choice" =~ ^[Yy]$ ]]; then
    echo "Installing Miniforge3..." > /dev/tty
    install_miniforge
fi

choice=$(prompt_user "Do you want to create RStudio environment R_4.3.3? (y/newname/n)")
if [[ "$choice" =~ ^[Yy]$ || "$choice" == "newname" ]]; then
    echo "Creating RStudio environment..." > /dev/tty
    create_rstudio_env "$choice"
fi

choice=$(prompt_user "Do you want to create a reticulate environment for R?")
if [[ "$choice" =~ ^[Yy]$ ]]; then
    echo "Creating reticulate environment..." > /dev/tty
    create_reticulate_env
fi

conda activate
conda clean --all -y
pip cache purge
