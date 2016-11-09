Rails.application.routes.draw do
  [
    '/',
    '/signin',
    '/signup',
    '/signout',
    '/apps',
    '/devices',
  ].each { |page| get page, to: 'pages#page' }

  scope :api do
    mount_devise_token_auth_for 'User', at: 'auth'

    # Apps API
    get    '/:team/apps',                       to: 'apps#index'
    post   '/:team/apps',                       to: 'apps#create'
    get '/:team/apps/:app_name',                to: 'apps#show'
    delete '/:team/apps/:app_name',             to: 'apps#destroy'
    post   '/:team/apps/:app_name/devices',     to: 'apps#add_device'
    post   '/:team/apps/:app_name/builds',      to: 'apps#build'
    post   '/:team/apps/:app_name/deployments', to: 'apps#deploy'

    # Devices API
    get    '/:team/devices',                            to: 'devices#index'
    post   '/:team/devices',                            to: 'devices#create'
    put    '/:team/devices/:device_name',               to: 'devices#update'
    delete '/:team/devices/:device_name',               to: 'devices#destroy'
    put    '/:team/devices/:device_name/relaunch',      to: 'devices#relaunch'
    get    '/:team/devices/:device_name/log',           to: 'devices#log'
    get    '/:team/devices/:device_name/envvars',       to: 'envvars#index'
    put    '/:team/devices/:device_name/envvars/:name', to: 'envvars#update'
    delete '/:team/devices/:device_name/envvars/:name', to: 'envvars#destroy'

    # API for BaseOS
    put  '/devices/:device_secret/heartbeat', to: 'baseos#heartbeat'
    get  '/devices/:device_secret/image',    to: 'baseos#image'
    get  '/devices/:device_secret/envvars',  to: 'baseos#envvars'
  end
end
