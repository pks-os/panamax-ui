require 'spec_helper'

describe RegistriesController do

  describe 'GET #index' do
    let(:registry) { [Registry.new] }

    before do
      Registry.stub(:all).and_return(registry)
    end

    it 'renders the index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'retrieves all registries' do
      get :index
      expect(assigns(:registries)).to eq registry
    end
  end

  describe 'POST #create' do
    let(:fake_registry) { [Registry.new(name: 'test', endpoint_url: 'localhost:5000')] }
    let(:registry_form_params) do
      { 'registry' =>
          { 'name' => 'foo',
            'endpoint_url' => 'localhost:1234'
          }
      }
    end

    context 'when create is successful' do

      before do
        Registry.any_instance.stub(:save)
      end

      it 'creates the registry' do
        expect(Registry).to receive(:new)
                           .with(
                             'name' => 'foo',
                             'endpoint_url' => 'localhost:1234'
                           )
                           .and_return(fake_registry)
        expect(fake_registry).to receive(:save)
        post :create, registry_form_params
      end
    end

    context 'when create is not successful' do

      before do
        Registry.any_instance.stub(:save).and_raise(StandardError.new)
      end

      it 'rescues an exception' do
        post :create, registry_form_params
        expect(response.body).to redirect_to(registries_url)
        expect(flash[:error]).to eq 'Your registry could not be added'
      end
    end
  end
end
