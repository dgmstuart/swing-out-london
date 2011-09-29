require 'v3/cartographer'
require 'v3/cartographer/header'
require 'v3/cartographer/gmap'
require 'v3/cartographer/gicon'
require 'v3/cartographer/gmarker'
require 'v3/cartographer/infowindow'
require 'v3/cartographer/cluster_icon'
require 'v3/cartographer/gpolyline'

Cartographer
Cartographer::Header
Cartographer::Gmap

ActionController::Base.send :include, Cartographer if defined?(ActionController)
ActiveRecord::Base.send     :include, Cartographer if defined?(ActiveRecord)
ActionView::Base.send       :include, Cartographer if defined?(ActionView)