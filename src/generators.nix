{ lib }:
{
  mkUserJs =
    prefs:
    prefs
    |> lib.mapAttrsToList (
      name: value:
      let
        serializedValue =
          if lib.isBool value then
            lib.strings.toJSON value
          else if lib.isString value then
            value |> toString |> lib.strings.toJSON
          else if lib.isInt value then
            value |> toString
          else if lib.isFloat value then
            value |> toString
          else if lib.isAttrs value then
            value |> lib.strings.toJSON |> lib.strings.toJSON
          else
            throw "Unserializable preference type";
      in
      ''user_pref("${name}", ${serializedValue});''
    )
    |> lib.concatStringsSep "\n";
  mkProfilesIni =
    names:
    names
    |> lib.imap (
      i: name: {
        ${"Profile${(i - 1) |> toString}"} = {
          # If a non-silentium instance of Firefox is open, Firefox will attempt to reuse that instance upon open if the name collides.
          "Name" = "silentium-${name}";
          "IsRelative" = 1;
          "Path" = "silentium-${name}";
          "Default" = if name == "default" then 1 else 0;
        };
      }
    )
    |> lib.mergeAttrsList
    |> (
      x:
      x
      // {
        "General" = {
          "StartWithLastProfile" = 1;
          "Version" = 2;
        };
      }
    )
    |> lib.generators.toINI { };
}
