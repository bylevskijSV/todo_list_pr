require 'rails_helper'

RSpec.describe "/tasks", type: :request do
  let(:task) { FactoryBot.create(:task, user_id: user.id) }
  let(:assigned_task) { FactoryBot.create(:task, assigned_to: user)}
  let(:valid_attributes) do
    { title: 'Test title!', description: 'Test description', user_id: 1 }
  end

  let(:assigned_valid_attributes) do
    { title: 'Test title!', description: 'Test description', status: 'new', user_id: 2, assigned_to_id: 1 }
  end

  let(:invalid_attributes) do
    { title: '', description: 'Test description', user_id: 1 }
  end
  describe 'not logged in' do
    describe 'GET /index' do
      it 'returns a redirect response' do
        get tasks_url
        expect(response).to have_http_status(:redirect)
      end
    end

    describe 'GET /show' do
      it 'returns a redirect response' do
        get task_url(FactoryBot.create(:task))
        expect(response).to have_http_status(:redirect)
      end
    end

    describe 'GET /new' do
      it 'returns a redirect response' do
        get new_task_url
        expect(response).to have_http_status(:redirect)
      end
    end

    describe 'GET /edit' do
      it 'returns a redirect response' do
        get edit_task_url(FactoryBot.create(:task))
        expect(response).to have_http_status(:redirect)
      end
    end

    describe 'POST /create' do
      it 'returns a redirect response' do
        post tasks_url, params: { task: valid_attributes }
        expect(response).to have_http_status(:redirect)
      end
    end

    describe 'PATCH /update' do
      it 'returns a redirect response' do
        patch task_url(FactoryBot.create(:task))
        expect(response).to have_http_status(:redirect)
      end
    end

    describe 'DELETE /destroy' do
      it 'returns a redirect response' do
        delete task_url(FactoryBot.create(:task))
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'logged in' do
    include_context :login_user

    describe 'GET /index' do
      it 'returns a success response' do
        get tasks_url
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        get task_url(task)
        expect(response).to be_successful
      end

      context 'luck assigned task' do
        it 'renders a successful response' do
          get task_url(assigned_task)
          expect(response).to be_successful
        end
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_task_url
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render a successful response' do
        get edit_task_url(task)
        expect(response).to be_successful
      end

      context 'edit-form assigned task' do
        it 'returns a redirect response' do
          get edit_task_url(assigned_task)
          expect(response).to have_http_status(:redirect)
        end
      end
    end

    describe 'GET /complete' do
      it 'returns a redirect response' do
        get complete_task_url(task)
        expect(response).to have_http_status(:redirect)
      end

      context 'complete assigned task' do
        it 'status not change' do
          get complete_task_url(assigned_task)
          expect(assigned_task.status).to eq('new')
        end

        it 'returns a redirect response' do
          get complete_task_url(assigned_task)
          expect(response).to have_http_status(:redirect)
        end
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new Task' do
          expect do
            post tasks_url, params: { task: valid_attributes }
          end.to change(Task, :count).by(1)
        end

        it 'creates and assigned new Task' do
          post tasks_url, params: { task: assigned_valid_attributes }
          expect(response).to redirect_to(tasks_url)
        end

        it 'redirects to the created tasks' do
          post tasks_url, params: { task: valid_attributes }
          expect(response).to redirect_to(tasks_url)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Task' do
          expect do
            post tasks_url, params: { task: invalid_attributes }
          end.to change(Task, :count).by(0)
        end

        it 'renders a successful response (i.e. to display the "new" template)' do
          post tasks_url, params: { task: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          { title: 'new test title', description: 'new test description' }
        end

        it 'updates the requested task' do
          patch task_url(task), params: { task: new_attributes }
          task.reload
          expect(task.title).to eq('new test title')
        end

        it 'redirects to the article' do
          patch task_url(task), params: { task: new_attributes }
          task.reload
          expect(response).to redirect_to(tasks_url)
        end

        context 'update assigned task' do
          it 'returns a redirect response' do
            patch task_url(assigned_task), params: { task: new_attributes }
            expect(response).to have_http_status(:redirect)
          end
        end
      end

      context 'with invalid parameters' do
        it 'renders a successful response (i.e. to display the "edit" template)' do
          patch task_url(task), params: { task: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested task' do
        expect do
          delete task_url(task)
        end.to change(Task, :count).by(0)
      end

      it 'redirects to the tasks list' do
        delete task_url(task)
        expect(response).to redirect_to(tasks_url)
      end

      context 'delete assigned task' do
        it 'destroys the requested task' do
          expect do
            delete task_url(assigned_task)
          end.to change(Task, :count).by(0)
        end

        it 'redirects to the tasks list' do
          delete task_url(assigned_task)
          expect(response).to redirect_to(tasks_url)
        end
      end
    end
  end
end
