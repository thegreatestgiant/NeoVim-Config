FROM ubuntu:jammy

RUN apt update && apt install -y git gcc make python3  ripgrep unzip tar curl openjdk-21-jdk wget python3-venv

COPY ./ /root/.config/nvim

RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && \
    install lazygit -D -t /usr/local/bin/ && \
    rm lazygit.tar.gz lazygit

RUN wget https://go.dev/dl/go1.26.1.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.26.1.linux-amd64.tar.gz && \
    rm go1.26.1.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

ENV NVM_DIR="/root/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    nvm use --lts && \
    npm install -g tree-sitter-cli && \
    ln -s $NVM_DIR/versions/node/$(nvm version)/bin/node /usr/local/bin/node && \
    ln -s $NVM_DIR/versions/node/$(nvm version)/bin/npm /usr/local/bin/npm && \
    ln -s $NVM_DIR/versions/node/$(nvm version)/bin/tree-sitter /usr/local/bin/tree-sitter

RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    rm nvim-linux-x86_64.tar.gz
ENV PATH="/opt/nvim-linux-x86_64/bin:${PATH}"

RUN nvim --headless "+Lazy! sync" +qa || true
RUN timeout 45s nvim --headless -c "MasonToolsInstall" || true
RUN nvim --headless -c "sleep 60" -c "qa"
RUN timeout 45s nvim --headless "+MasonUpdate" +qa || true
RUN timeout 45s nvim --headless "+MasonToolsInstallSync" +qa || true

ENTRYPOINT ["nvim"]
