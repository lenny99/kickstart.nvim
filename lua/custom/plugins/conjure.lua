return {
  'Olical/conjure',
  ft = { 'lisp', 'asd' },
  init = function()
    local function lisp_project()
      local asd_files = vim.fs.find(function(name)
        return name:match('%.asd$') ~= nil
      end, {
        path = vim.fn.getcwd(),
        type = 'file',
        upward = true,
        limit = 10,
      })

      local asd_file
      for _, candidate in ipairs(asd_files) do
        if not candidate:match('[%-_]tests?%.asd$') then
          asd_file = candidate
          break
        end
      end
      asd_file = asd_file or asd_files[1]

      if not asd_file then
        return nil
      end

      return {
        asd_file = asd_file,
        root = vim.fs.dirname(asd_file),
        system = vim.fn.fnamemodify(asd_file, ':t:r'),
      }
    end

    local function start_swank()
      local project = lisp_project()
      if not project or vim.fn.executable('sbcl') ~= 1 then
        vim.notify('Cannot start Swank: no project ASDF file or sbcl found', vim.log.levels.ERROR)
        return
      end

      local connected, socket = pcall(vim.fn.sockconnect, 'tcp', '127.0.0.1:4005', { rpc = false })
      if connected and socket > 0 then
        vim.fn.chanclose(socket)
        vim.notify('Swank is already running on port 4005')
        return
      end

      local job = vim.fn.jobstart({
        'sbcl',
        '--eval', '(ql:quickload :swank)',
        '--eval', string.format('(asdf:load-asd #P%q)', project.asd_file),
        '--eval', string.format('(ql:quickload %q)', project.system),
        '--eval', '(swank:create-server :dont-close t :port 4005)',
      }, {
        cwd = project.root,
        on_stderr = function(_, data)
          if data and #data > 0 then
            vim.schedule(function()
              vim.notify(table.concat(data, '\n'), vim.log.levels.ERROR)
            end)
          end
        end,
        on_exit = function(_, code)
          vim.schedule(function()
            if code ~= 0 then
              vim.notify('Swank exited with status ' .. code, vim.log.levels.ERROR)
            end
          end)
        end,
      })

      if job <= 0 then
        vim.notify('Failed to start Swank', vim.log.levels.ERROR)
        return
      end

      vim.g.conjure_swank_job = job
      vim.notify('Starting Swank for ' .. project.system)

      vim.defer_fn(function()
        if vim.fn.exists(':ConjureConnect') == 2 then
          vim.cmd('ConjureConnect 4005')
        end
      end, 1000)
    end

    local function stop_swank()
      local job = vim.g.conjure_swank_job
      if job and vim.fn.jobwait({ job }, 0)[1] == -1 then
        vim.fn.jobstop(job)
        vim.g.conjure_swank_job = nil
        vim.notify('Stopped Swank')
      else
        vim.notify('Swank job is not owned by this Neovim session', vim.log.levels.WARN)
      end
    end

    local function swank_status()
      local connected, socket = pcall(vim.fn.sockconnect, 'tcp', '127.0.0.1:4005', { rpc = false })
      if connected and socket > 0 then
        vim.fn.chanclose(socket)
        vim.notify('Swank is reachable on 127.0.0.1:4005')
      else
        vim.notify('Swank is not reachable', vim.log.levels.WARN)
      end
    end

    vim.api.nvim_create_user_command('LispSwankStart', start_swank, {})
    vim.api.nvim_create_user_command('LispSwankStop', stop_swank, {})
    vim.api.nvim_create_user_command('LispSwankStatus', swank_status, {})
    vim.api.nvim_create_user_command('LispSwankRestart', function()
      stop_swank()
      vim.defer_fn(start_swank, 100)
    end, {})

    start_swank()
    vim.g['conjure#debug'] = true

    vim.keymap.set('n', '<leader>cs', '<cmd>ConjureSchool<cr>', { desc = '[C]onjure [S]chool' })
    vim.keymap.set('n', '<leader>cl', '<cmd>ConjureLog<cr>',    { desc = '[C]onjure [L]og' })
    vim.keymap.set('n', '<leader>ci', '<cmd>ConjureInterrupt<cr>', { desc = '[C]onjure [I]nterrupt' })
    vim.keymap.set('n', '<leader>cf', '<cmd>ConjureEvalFile<cr>', { desc = '[C]onjure eval [F]ile (load)' })
    vim.keymap.set('n', '<leader>ce', '<cmd>ConjureEvalForm<cr>', { desc = '[C]onjure [E]val form' })
    vim.keymap.set('v', '<leader>ce', '<cmd>ConjureEvalRegion<cr>', { desc = '[C]onjure [E]val region' })
  end,
  dependencies = {
    {
      'PaterJason/cmp-conjure',
      ft = { 'lisp', 'asd' },
      config = function()
        local cmp = require('cmp')
        local config = cmp.get_config()
        config.sources = config.sources or {}
        table.insert(config.sources, { name = 'conjure' })
        cmp.setup(config)
      end,
    },
  },
}
