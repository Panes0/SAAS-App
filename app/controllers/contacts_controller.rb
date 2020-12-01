class ContactsController < ApplicationController
  # GET request from /contact-us
  # Show new contact Form
  def new
    @contact = Contact.new
  end

  # POST request to /contacts
  def create
    # Mass assigment of FormFields into Contact object
    @contact = Contact.new(contact_params)
    # Save the Contact object to DB
    if @contact.save
      # Store the parameters to variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug variables into contact mailer
      # email method and send email
      ContactMailer.contact_email(name, email, body).deliver
      # Store success msg into flash Hash
      # and redirect to new action
      flash[:success] = "Message sent."
      redirect_to new_contact_path
    else
      # Store error msg into flash Hash
      # and redirect to new action
      flash[:danger] = @contact.errors.full_messages.join(", ")
       redirect_to new_contact_path
    end
  end

  private
  # Strong parameters to store data from form fields
    def contact_params
       params.require(:contact).permit(:name, :email, :comments)
    end

end
