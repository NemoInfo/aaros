let
  email = "aaronpanaitescu@gmail.com";
  name = "Aaron";
in {
  programs.git = {
    enable = true;
    settings = { 
      user.email = email;
      user.name  = name;
      init.defaultBranch = "main";
    };
  };
}
