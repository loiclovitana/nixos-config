{ ... }:

{
  # Run ssh-agent as a systemd user service, started with the session. It only
  # holds keys in memory; the keys themselves live in ~/.ssh and are not part of
  # this repo. Paired with AddKeysToAgent in the user's ssh config
  # (see home/home-manager.nix), id_perso is added to the agent the first time
  # it is used and stays unlocked for the rest of the session.
  programs.ssh.startAgent = true;
}
