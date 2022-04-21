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

module RedmineMyPagePaginations
  module Patches
    module UserPreferencePatch
      def self.included(base) # :nodoc: 
      
        base.send(:include, InstanceMethods)
        
        base.class_eval do
          safe_attributes 'my_page_pagination' if self.included_modules.include?(Redmine::SafeAttributes)
        end
      end
      
      module InstanceMethods
      
        def my_page_pagination; self["my_page_pagination"] end
        def my_page_pagination=(value); self["my_page_pagination"]=value end
        
        def my_page_pagination_per_page( query )
        
          id = query.id ? "#{query.id}" : ::Digest::MD5.hexdigest(query.name) # digest to support non-latin chars without having to transliterate
          per_page   = (self["my_page_pagination"] && self["my_page_pagination"].dig(id, "per_page").presence) || Setting.search_results_per_page
          per_page.to_i > 0 ? per_page.to_i : 10
        end 
        
        def my_page_pagination_page( query )
          id = query.id ? "#{query.id}" : ::Digest::MD5.hexdigest(query.name) # digest to support non-latin chars without having to transliterate
          page   = (self["my_page_pagination"] && self["my_page_pagination"].dig(id, "page"))
          page.to_i > 0 ? page.to_i : 1
        end 
        
      end
    end
  end
end

unless UserPreference.included_modules.include?(RedmineMyPagePaginations::Patches::UserPreferencePatch)
  UserPreference.send(:include, RedmineMyPagePaginations::Patches::UserPreferencePatch)
end
