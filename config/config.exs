import Config

case Mix.env do
  :test ->  config :ex_aequo, sys_interface: ExAequo.SysInterface.Mock
  _     ->  config :ex_aequo, sys_interface: ExAequo.SysInterface.Implementation
end
