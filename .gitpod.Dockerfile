FROM gitpod/workspace-full
RUN sudo apt-get update >/dev/null && sudo apt-get install jq netcat
