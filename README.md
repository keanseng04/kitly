We're going to build a simple link shortener, a la <a href="http://bitly.com/">bitly</a>.

You'll have one model <code>Url</code>, which is a list of URLs that people have entered.
<h2>Learning Goals</h2>
<ul>
	<li>Deepen your understanding of HTTP redirects.</li>
	<li>Explore ActiveRecord callbacks.</li>
</ul>
<h2>Objectives</h2>
<h3>Simple Shortener</h3>
Start with this <a href="http://ge.tt/8fpASR22/v/0?c">empty Sinatra skeleton</a>.

We have one resource: <code>Urls</code>. For our controllers, we have a URL that lists all our <code>Url</code> objects and another URL that, when POSTed to, creates a <code>Url</code> object.

We'll also need a URL that redirects us to the full (unshortened) URL. If you've never used bitly, use it now to get a feel for how it works.

The controller methods should look like this:
<div class="highlight">
<pre>get <span class="s1">'/'</span> <span class="k">do</span>
  <span class="c"># let user create new short URL, display a list of shortened URLs</span>
end

post <span class="s1">'/urls'</span> <span class="k">do</span>
  <span class="c"># create a new Url</span>
end

<span class="c"># e.g., /q6bda</span>
get <span class="s1">'/:short_url'</span> <span class="k">do</span>
  <span class="c"># redirect to appropriate "long" URL</span>
end
</pre>
</div>
Use a <code>before_save</code> callback in the <code>Url</code> model to generate the short URL.
<h3>Counter!</h3>
Add a <code>click_count</code> field to your <code>urls</code> table, which keeps track of how many times someone has visited the shortened URL. Add code to the appropriate place in your controller code so that any time someone hits a short URL the counter for the appropriate <code>Url</code> is incremented by 1.
<h3>Add Validations</h3>
Add a validation to your <code>Url</code> model so that only <code>Urls</code> with valid URLs get saved to the database. Read up on<a href="http://guides.rubyonrails.org/active_record_validations.html">ActiveRecord validations</a>.

What constitutes a "valid URL" is up to you. It's a sliding scale, from validations that would permit lots of invalid URLs to validations that might reject lots of valid URLs. When you get into it you'll see that expressing the fact "x is a valid URL" in Ruby Land or SQL Land is never perfect.

For example, the valid URL could range across:

<strong>A valid URL is...</strong>
<ul>
	<li>Any non-empty string</li>
	<li>Any non-empty string that starts with "http://" or "https://"</li>
	<li>Any string that the <a href="http://www.ruby-doc.org/stdlib-1.9.3/libdoc/uri/rdoc/URI.html">Ruby URI module</a> says is valid</li>
	<li>Any URL-looking thing which responds to a HTTP request, i.e., we actually check to see if the URL is accessible via HTTP</li>
</ul>
Some of these are easily expressible in SQL Land. Some of these are hard to express in SQL Land, but ActiveRecord comes with pre-built validation helpers that make it easy to express in Ruby Land. Others require <a href="http://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations">custom validations</a>that express logic unique to our application domain.

The rule of thumb is that where we can, we want to always express constraints in Ruby Land and also express them in SQL Land where feasible.
<h3>Add Error Handling</h3>
When you try to save (create or update) an ActiveRecord object that has invalid data, ActiveRecord will fail. Some methods like <code>create!</code> and <code>save!</code> throw an exception. Others like <code>create</code> (without the <code>!</code> bang) return the resulting object whether the object was saved successfully to the database or not, while <code>save</code> will return <code>false</code> if perform_validation is true and any validations fail. See <a href="http://apidock.com/rails/ActiveRecord/Base/create/class">create</a> and <a href="http://apidock.com/rails/ActiveRecord/Base/save">save</a> for more information.

You can always call <a href="http://guides.rubyonrails.org/active_record_validations.html#valid-questionmark-and-invalid-questionmark">valid? or invalid?</a> on an ActiveRecord object to see whether its data is valid or invalid.

Use this and the <a href="http://guides.rubyonrails.org/active_record_validations.html#validations-overview-errors">errors</a> method to display a helpful error message if a user enters an invalid URL, giving them the opportunity to correct their error.
<h2>More on Validations, Constraints, and Database Consistency</h2>
We often want to put constraints on what sort of data can go into our database. This way we can guarantee that all data in the database conforms to certain standards, e.g., there are no users missing an email address. Guarantees of this kind - ensuring that the data in our database is never confusing or contradictory or partially changed or otherwise invalid - are called <strong>consistency</strong> .

If we think of this as a fact from Fact Land, these constraints look like:
<ul>
	<li>A user must have a first_name</li>
	<li>A user must have an email</li>
	<li>Two user's can't have the same email address, or equivalently, each user's email must be unique</li>
	<li>A Craigslist post's URL must be a valid URL, for some reasonable definition of valid</li>
</ul>
These facts can be recorded in both SQL Land and in Ruby Land, like this:
<table class="table table-bordered table-striped">
<thead>
<tr>
<th>Fact Land</th>
<th>SQL Land</th>
<th>Ruby Land</th>
</tr>
</thead>
<tbody>
<tr>
<td>A user must have an email address</td>
<td><code>NOT NULL</code> constraint on <code>email</code>field</td>
<td><code>validates :email, :presence =&gt; true</code></td>
</tr>
<tr>
<td>A user must have a first name</td>
<td><code>NOT NULL</code> constraint on<code>first_name</code> field</td>
<td><code>validates :first_name, :presence =&gt; true</code></td>
</tr>
<tr>
<td>A user's email address must be unique</td>
<td><code>UNIQUE INDEX</code> on <code>email</code> field</td>
<td><code>validates :email, :uniqueness =&gt; true</code></td>
</tr>
</tbody>
</table>
