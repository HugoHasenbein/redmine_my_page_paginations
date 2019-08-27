# encoding: utf-8
#
# Redmine plugin to add pagination links to my page queries
#
# Copyright © 2018 Stephan Wenzel <stephan.wenzel@drwpatent.de>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

class MyPagePaginationsController < ApplicationController

  before_action :authorize_loggedin

  def update
    my_page_pagination = User.current.pref.my_page_pagination.presence || {}
    per_page = params[:per_page]
        page = params[:page]
    page= "1" if per_page.present? #reset page to avoid pages off range after altering per_page
    User.current.pref.my_page_pagination = my_page_pagination.deep_merge(params[:id] => {"per_page" => per_page, "page" => page}.compact)
    User.current.pref.save
    redirect_to :back
  end #def
  
  private

  def authorize_loggedin
    deny_access unless User.current.logged?
  end #def
  
end #class