# Carefully analyze the below few segments of code. The server takes an total
# average of 1850ms to render this page. What strategies would you use to optimize the
# rendering time? (Hint: there’s more than 1 strategy to be implemented)

# Controller
def index
  @themes = Theme.includes(:categories).published.order(created_at: :desc)
  # takes an average of 350ms

  @featured_infographics = Infographic.includes(:categories).where(featured: true)
  # takes an average of 500ms

  respond_to do |format|
    format.html
    format.json { render json: @themes }
  end
end

# View (part of it) - this portion takes an average of 1000ms to render

<% @themes.each do |theme| %>
  <li id="pikto-theme-item-<%= theme.id %>" class="theme-items">

    <div class="the-infographic <%= theme.pro? && current_user.is_free? ? 'protemplate'
    : '' %>">

      <% if theme.is_new? %>
        <i class="icon-tagnew"></i>
      <% end %>

      <% if theme.is_featured? %>
        <i class="icon-tagfeatured"></i>
      <% end %>

      <div class="the-infographic-img">
        <a href="#">
          <%= image_tag(image_path('v4/b/loading.gif'), alt: 'infographics', class: 'lazy
      pikto-loading-lg', data: { original: theme.snapshot.url(:medium) }) %>
        </a>
      </div>

    </div>

    <div class="the-infographic-details">
      <%= theme.try(:title) %>
    </div>

  </li>
<% end %>