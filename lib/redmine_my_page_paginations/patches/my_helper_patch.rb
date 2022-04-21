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
    module MyHelperPatch
      def self.included(base) # :nodoc: 
        base.send(:include, InstanceMethods)
        
        base.class_eval do
        
          def render_issuesassignedtome_block(block, settings)
            query = IssueQuery.new(:name => l(:label_assigned_to_me_issues), :user => User.current)
            query.add_filter 'assigned_to_id', '=', ['me']
            query.column_names = settings[:columns].presence || ['project', 'tracker', 'status', 'subject']
            @issue_pages = Redmine::Pagination::Paginator.new(
              query.issue_count, 
              User.current.pref.my_page_pagination_per_page(query),
              User.current.pref.my_page_pagination_page(query)
            )
            query.sort_criteria = settings[:sort].presence || [['priority', 'desc'], ['updated_on', 'desc']]
              issues = query.issues(:limit => @issue_pages.per_page, :offset => @issue_pages.offset )
            
            render :partial => 'my/patched_blocks/issues', :locals => {:query => query, :issues => issues, :block => block}
          end
          
          def render_issuesreportedbyme_block(block, settings)
            query = IssueQuery.new(:name => l(:label_reported_issues), :user => User.current)
            query.add_filter 'author_id', '=', ['me']
            query.column_names = settings[:columns].presence || ['project', 'tracker', 'status', 'subject']
            @issue_pages = Redmine::Pagination::Paginator.new(
              query.issue_count, 
              User.current.pref.my_page_pagination_per_page(query),
              User.current.pref.my_page_pagination_page(query)
            )
            query.sort_criteria = settings[:sort].presence || [['updated_on', 'desc']]
              issues = query.issues(:limit => @issue_pages.per_page, :offset => @issue_pages.offset )
            
            render :partial => 'my/patched_blocks/issues', :locals => {:query => query, :issues => issues, :block => block}
          end
          
          def render_issueswatched_block(block, settings)
            query = IssueQuery.new(:name => l(:label_watched_issues), :user => User.current)
            query.add_filter 'watcher_id', '=', ['me']
            query.column_names = settings[:columns].presence || ['project', 'tracker', 'status', 'subject']
            @issue_pages = Redmine::Pagination::Paginator.new(
              query.issue_count, 
              User.current.pref.my_page_pagination_per_page(query),
              User.current.pref.my_page_pagination_page(query)
            )
            query.sort_criteria = settings[:sort].presence || [['updated_on', 'desc']]
              issues = query.issues(:limit => @issue_pages.per_page, :offset => @issue_pages.offset )
            
            render :partial => 'my/patched_blocks/issues', :locals => {:query => query, :issues => issues, :block => block}
          end
          
          def render_issuequery_block(block, settings)
            query = IssueQuery.visible.find_by_id(settings[:query_id])
            if query
              query.column_names = settings[:columns] if settings[:columns].present?
              query.sort_criteria = settings[:sort] if settings[:sort].present?
              @issue_pages = Redmine::Pagination::Paginator.new(
                query.issue_count, 
                User.current.pref.my_page_pagination_per_page(query),
                User.current.pref.my_page_pagination_page(query)
              )
              issues = query.issues(:limit => @issue_pages.per_page, :offset => @issue_pages.offset )
              render :partial => 'my/patched_blocks/issues', :locals => {:query => query, :issues => issues, :block => block, :settings => settings}
            else
              queries = IssueQuery.visible.sorted
              render :partial => 'my/blocks/issue_query_selection', :locals => {:queries => queries, :block => block, :settings => settings}
            end
          end #def
          
        end #base
      end
            
      module InstanceMethods
      end
    end
  end
end

unless MyHelper.included_modules.include?(RedmineMyPagePaginations::Patches::MyHelperPatch)
  MyHelper.send(:include, RedmineMyPagePaginations::Patches::MyHelperPatch)
end
