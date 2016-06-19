require_relative '../support/controllers/shared_examples.rb'
require_relative '../support/controllers/shared_contexts.rb'

RSpec.describe EventsController do
  describe 'GET #index' do
    subject { get :index }

    include_examples 'redirects guest'
    include_examples 'calls authorize with logged in user', Event
  end

  describe 'GET #show' do
    let(:event) { create :event }

    subject { get :show, params: { id: event.id } }

    include_examples 'redirects guest'

    include_context 'user is logged in' do
      it 'calls authorize' do
        expect(controller).to receive(:authorize).with(event)
        subject
      end

      include_examples 'redirects unauthorized user'

      include_context 'user is authorized' do
        it_behaves_like 'successful request'
      end

    end
  end

  describe 'GET #edit' do
    let(:event) { create :event }

    subject { get :edit, params: { id: event.id } }

    include_examples 'redirects guest'

    include_context 'user is logged in' do
      it 'calls authorize' do
        expect(controller).to receive(:authorize).with(event)
        get :edit, params: { id: event.id }
      end

      include_context 'user is authorized' do
        it_behaves_like 'successful request'
      end

      include_examples 'redirects unauthorized user'
    end
  end

  describe 'POST #create' do
    let(:event_params) { attributes_for :event }

    subject { post :create, params: { event: event_params } }

    include_examples 'redirects guest'

    include_context 'user is logged in' do
      include_examples 'calls authorize with', Event
      include_examples 'redirects unauthorized user'

      include_context 'user is authorized' do
        context 'with valid params' do
          it 'creates a new Event' do
            expect {
              post :create, params: { event: event_params }
            }.to change(Event, :count).by(1)
          end

          it 'sets the right flash' do
            post :create, params: { event: event_params }
            expect(response).to redirect_to events_path
            expect(controller).to set_flash[:notice].to 'Event was created successfully'
          end
        end

        context 'with invalid params' do
          let(:invalid_params) { { name: nil, description: nil } }

          it 'creates a new Event' do
            expect {
              post :create, params: { event: invalid_params }
            }.not_to change(Event, :count)
          end

          it 'sets the right flash' do
            post :create, params: { event: invalid_params }
            expect(response).to redirect_to events_path
            expect(controller).to set_flash[:alert].to 'Event could not be created'
          end
        end
      end
    end
  end

  describe 'PUT #update' do
    let(:event) { create :event }
    let(:event_params) { { name: 'New Event Name' } }

    subject { put :update, params: { id: event.id, event: event_params } }

    include_examples 'redirects guest'

    include_context 'user is logged in' do
      include_examples 'calls authorize with', Event
      include_examples 'redirects unauthorized user'

      include_context 'user is authorized' do
        context 'with valid params' do
          it 'updates the event' do
            expect do
              put :update, params: { id: event.id, event: event_params }
              event.reload
            end.to change(event, :name)
          end

          it 'sets the right flash' do
            put :update, params: { id: event.id, event: event_params }
            expect(response).to redirect_to events_path
            expect(controller).to set_flash[:notice].to 'Event was successfully updated'
          end
        end

        context 'with invalid params' do
          let(:invalid_params) { { name: nil } }

          it 'does not update the event' do
            expect do
              put :update, params: { id: event.id, event: invalid_params }
              event.reload
            end.not_to change(event, :name)
          end

          it 'sets the right flash' do
            put :update, params: { id: event.id, event: invalid_params }
            expect(response).to have_http_status :ok
            expect(flash[:alert]).to eq "Event could not be updated"
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let(:event) { create :event }

    subject { delete :destroy, params: { id: event.id } }

    include_examples 'redirects guest'

    include_context 'user is logged in' do
      include_examples 'redirects unauthorized user'

      it 'calls authorize' do
        expect(controller).to receive(:authorize).with(event)
        subject
      end

      include_context 'user is authorized' do
        it 'works' do
          subject
          expect(response).to redirect_to events_path
          expect(controller).to set_flash[:notice].to t('events.destroy.success')
        end
      end
    end
  end
end
