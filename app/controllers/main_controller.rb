class MainController < ApplicationController

  def index
    @areas = Area.mapraid
    @segments = Segment.all
    @update = Update.find('segments')
    @nav = [{ t('nav-first-page') => '/'}]
  end
  
  def segments
    @area = CityMapraid.find(params['id'])
    @update = Update.find('segments')
    @editor_level = (cookies[:editor_level].nil? ? 6 : cookies[:editor_level].to_i)
    @wme_url = (cookies[:wme_url].nil? ? 'https://www.waze.com/' : cookies[:wme_url])
    @nav = [{@area.name => "/segments/#{@area.gid}"},{@area.area.name => "/segments_area/#{@area.area.id}"},{ t('nav-first-page') => '/'}]
  end

  def segments_area
    @area = Area.find(params['id'])
    @update = Update.find('segments')
    @editor_level = (cookies[:editor_level].nil? ? 6 : cookies[:editor_level].to_i)
    @wme_url = (cookies[:wme_url].nil? ? 'https://www.waze.com/' : cookies[:wme_url])
    @nav = [{@area.name => '#'},{ t('nav-first-page') => '/'}]
    render :segments
  end
  
  def options
    @wme_url = (cookies[:wme_url].nil? ? 'https://www.waze.com/' : cookies[:wme_url])
    @editor_level = (cookies[:editor_level].nil? ? 6 : cookies[:editor_level].to_i)
    @nav = [{t('options-change') => "#"},{ t('nav-first-page') => '/'}]
  end
  
  def save
    cookies.permanent[:wme_url] = params['wme_url']
    cookies.permanent[:editor_level] = params['editor_level'].to_i
    redirect_to action: 'index'
  end
end
