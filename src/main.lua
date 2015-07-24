local lustache = require "lustache"

-- Helper that adds the commonly used data and lambdas for templates
function get_base_data()
   return {
      pages = alven.get_pages(),
      -- lambda for retrieving URLs for theme assets
      theme_url = function (render, text)
         return alven.get_theme_url(text)
      end
   }
end

-- Helper for rendering given template as a partial to the base.mustache 
-- template. Renders the main_nav.mustache template as a partial, which
-- means the given data table needs to contain a field named "pages" that
-- contains a list of all pages.
-- 
-- base.mustache expects the "curr_title" field to be present also
--
-- Use the "get_base_data" function to get the needed fields.
function render_by_base(content_name, data)
   local base_t = alven.read_theme_file("templates/base.mustache")

   local partials = {
      content  = alven.read_theme_file("templates/" .. content_name),
      main_nav = alven.read_theme_file("templates/main_nav.mustache")
   }

   return lustache:render(base_t, data, partials)
end

local curr_page = alven.get_current_page()
local data      = get_base_data()

if (curr_page == nil) or (not curr_page.is_public) then
   data.curr_title = "Not found"

   output = render_by_base("not_found.mustache", data)
else
   data.curr_title = curr_page.name
   data.curr_page  = curr_page

   output = render_by_base("page_content.mustache", data)
end

alven.output(output)
