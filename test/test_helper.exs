ExUnit.start()

ExAequo.SysInterface.Mock.start_link()

Mox.defmock(Support.SysInterface.Mox, for: ExAequo.SysInterface.Behavior)
