Feeder::Engine.routes.draw do
  match "receiver/:token/" => "receiver#receive"
end
