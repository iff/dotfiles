{
  window = {
    dynamic_padding = true;
    dynamic_title = true;
  };

  selection = {
    semantic_escape_chars = ",│`|:\"' ()[]{}<>\t┃";
    save_to_clipboard = true;
  };

  mouse = {
    hide_when_typing = false;
  };

  keyboard.bindings = [{
    chars = "\u001B[13;2u";
    key = "Return";
    mods = "Shift";
  }
    {
      chars = "\u001B[13;5u";
      key = "Return";
      mods = "Control";
    }];

  # Live config reload (changes require restart)
  general.live_config_reload = true;
}
