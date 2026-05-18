{ lib, libnotify, socat, writeShellApplication }:

let
  name = "nfsm-cli";
in
writeShellApplication {
  inherit name;
  runtimeInputs = [ libnotify socat ];
  text = ''
    SOCKET=''${NFSM_SOCKET:-/run/user/1000/nfsm.sock}
    trap 'notify-send --icon="${./assets/icon.png}" --app-name="NFSM" "Niri FullScreen Manager" "Failed to connect to NFSM_SOCKET: $SOCKET" && niri msg action fullscreen-window' ERR

    CMD=''${1:-fullscreen}
    case "$CMD" in
      fullscreen)
        echo 'FullscreenRequest' | socat - UNIX-CONNECT:"$SOCKET"
        ;;
      maximize)
        echo 'MaximizeRequest' | socat - UNIX-CONNECT:"$SOCKET"
        ;;
      *)
        echo "Unknown command: $CMD" >&2
        exit 1
        ;;
    esac
  '';

  meta = {
    description = "Niri FullScreen Manager Client (nfsm-cli)";
    homepage = "https://github.com/gvolpe/nfsm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gvolpe ];
    mainProgram = name;
    platforms = lib.platforms.linux;
  };
}
