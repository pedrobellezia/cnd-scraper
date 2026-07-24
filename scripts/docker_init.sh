#!/bin/bash

# Iniciar o Xvfb em background
Xvfb :99 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset &
export DISPLAY=:99

# Aguardar a inicialização do Xvfb
sleep 2

# Configurar e iniciar o x11vnc
VNC_ARGS="-display :99 -forever -shared -rfbport 5900"


if [ -n "$VNC_PASSWORD" ]; then
    echo "Iniciando x11vnc com senha..."
    mkdir -p ~/.vnc
    x11vnc -storepasswd "$VNC_PASSWORD" ~/.vnc/passwd
    x11vnc $VNC_ARGS -rfbauth ~/.vnc/passwd -bg
else
    echo "Iniciando x11vnc sem senha..."
    x11vnc $VNC_ARGS -nopw -bg
fi

# Aguardar mais um instante
sleep 1

# Executar a aplicação principal
exec uvicorn app.app:app --host "$HOST" --port "$PORT"
