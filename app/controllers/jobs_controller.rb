class JobsController
  include ResponseHelper
  include ParamsHelper

  def show(env)
    params = env['rack.route_params']
    job = JOB_REPO.find(params[:id])

    if job
      build_response({ job: build_job_data(job) })
    else
      error_data = I18n.t('errors.not_found')

      error_response([error_data], 404)
    end
  end

  private

  def build_job_data(job)
    {
      id: job.id,
      status: job.status,
      errors: job.errors,
      object_id: job.object_id,
      created_at: job.created_at
    }
  end
end
