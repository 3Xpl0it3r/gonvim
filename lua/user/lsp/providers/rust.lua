local M = {}

local util = require("lspconfig/util")

M.rust_analyzer = {
	cmd = { "rust-analyzer" },
	filetype = { "rust" },
	root_dir = util.root_pattern("Cargo.toml", "rust-project.json"),
	settings = {
		["rust-analyzer"] = {
			assist = {
				importGranularity = "module",
				importEnforceGranularity = true,
				importPrefix = "self",
			},
			cargo = {
				buildScripts = { enable = true },
				loadOutDirsFromCheck = true,
				autoreload = true,
				allFeatures = true,
				useRustWrapper = true,
				sysroot = "discover", -- sysroot相对路径. 或“discover”以尝试通过“rustc--print sysroot”自动找到它
			},
			check = {
				allTargets = true,
				-- command = "check", -- 用于 cargo check 的命令。
				command = "clippy", -- 用于 cargo check 的命令。
				-- extraArgs = vim.tbl_deep_extend("force", { "--no-deps" }, lints), -- cargo check 的额外参数。
				extraArgs = { "--no-deps" },
				extraEnv = {}, -- 运行 cargo check 时将设置的额外环境变量。扩展 rust-analyzer.cargo.extraEnv 。
				features = "all", -- 要激活的功能列表。默认为 rust-analyzer.cargo.features 。设置为 "all" ，将 --all-features 传递给Cargo。
				invocationLocation = "workspace", -- 指定运行检查的工作目录。-“workspace”：对相应工作区的根目录中的工作区进行检查。
				-- 如果 rust-analyzer.cargo.checkOnSave.invocationStrategy 设置为 once ，则返回到“root”。-“root”：在项目的根目录中运行检查。
				-- 此配置仅在设置了 rust-analyzer.cargo.buildScripts.overrideCommand 时有效。
				invocationStrategy = "per_workspace", -- 指定运行checkOnSave命令时要使用的调用策略。
				-- 如果设置了 per_workspace ，则将对每个工作区执行该命令。如果设置了 once ，则该命令将执行一次。
				-- 此配置仅在设置了 rust-analyzer.cargo.buildScripts.overrideCommand 时有效。
				noDefaultFeatures = nil, -- 是否将 --no-default-features 传递给Cargo。
				overrideCommand = nil, -- 重写铁锈分析器在保存时用于诊断的命令，而不是 cargo check 。该命令是输出json所必需的，
				-- 因此应该包括 --message-format=json 或类似的选项（如果您的客户端支持 colorDiagnosticOutput 实验功能，
				-- 则可以使用 --message-format=json-diagnostic-rendered-ansi ）。
				-- cargo check --workspace --message-format=json --all-targets
				targets = nil, -- 检查特定目标。如果为空，则默认为 rust-analyzer.cargo.target 。
				-- 可以是单个目标，例如 "x86_64-unknown-linux-gnu" 或目标列表，例如 ["aarch64-apple-darwin", "x86_64-apple-darwin"] 。
			},
			cachePriming = {
				enable = true, -- Warm up caches on project load.
				num = 0, -- How many worker threads to handle priming caches. The default 0 means to pick automatically.
			},
			completion = { -- 补全相关配置
				autoimport = { enable = true },
				autoself = { enable = true },
				callable = { snippets = "fill_arguments" }, -- 完成函数时是否添加括号和参数片段。
				limit = nil, -- 要返回的最大完成次数。如果 None ，则极限为无穷大。
				postfix = { enable = true }, -- Whether to show postfix snippets like dbg, if, not, etc.
				privateEditable = { enable = true },
				snippets = { custom = nil },
			},
			imports = {
				granularity = { enforce = true, group = "crate", enable = true },
				group = { enable = true },
				merge = { glob = true },
				prefer = { no = { std = false } },
				prefix = "plain", -- crate,self
			},
			diagnostics = {
				enable = true,
				disabled = {}, -- 要禁用的锈蚀分析仪诊断列表。
				experimental = { enable = false }, -- 是否显示可能比平时有更多假阳性的实验性锈蚀分析仪诊断。
				remapprefix = {}, -- 解析诊断文件路径时要替换的前缀的映射。这应该是传递给 rustc 的内容作为 --remap-path-prefix 的反向映射。
				warningsAsHint = {}, -- 应以提示严重性显示的警告列表。
				warningsAsInfo = {
					"unused_variables",
				}, -- 应与信息严重性一起显示的警告列表。
				files = {
					excludeDirs = {}, -- 锈蚀分析器将忽略这些目录。它们是相对于工作区根目录的，不支持glob。您可能还需要将文件夹添加到代码的 files.watcherExclude 中。
					watcher = "client", -- 控制文件监视实现。
				},
			},
			highlightRelated = {
				breakPoints = {
					enable = true, -- 当光标位于 break 、 loop 、 while 或 for 关键字上时，启用相关引用的高亮显示。
				},
				closureCaptures = {
					enable = true, -- 当光标位于闭包的 | 或move关键字上时，启用对闭包的所有捕获的高亮显示。
				},
				exitPoints = {
					enable = true, -- 当光标位于 return 、 ? 、 fn 或返回类型箭头（ → ）上时，启用所有退出点的高亮显示。
				},
				references = {
					enable = true, -- 当光标位于任何标识符上时，启用相关引用的高亮显示。
				},
				yieldPoints = {
					enable = true, -- 当光标位于任何 async 或 await 关键字上时，启用高亮显示循环或块上下文的所有断点。
				},
			},
			hover = {
				memoryLayout = {
					enable = true,
					alignment = "hexadecimal",
					niches = false,
					offset = "hexadecimal",
				},
				actions = {
					enable = true, -- 是否在Rust文件中显示悬停操作。
				},
			},
			lens = {
				enable = true,
				debug = { enable = true },
				forceCustomCommands = true,
				implementations = { enable = true },
				location = "above_name",
				references = {
					adt = {
						enable = true, -- 是否显示Struct、Enum和Union的 References 镜头。仅在设置了 rust-analyzer.lens.enable 时适用。
					},
					enumVariant = {
						enable = true, -- 是否显示枚举变体的 References 镜头。仅在设置了 rust-analyzer.lens.enable 时适用。
					},
					method = {
						enable = true,
					},
					trait = {
						enable = true,
					},
				},
			},
			-- linkedProjects = {}, -- 禁用项目自动发现以支持显式指定的项目集。
			-- 元素必须是指向 Cargo.toml 、 rust-project.json 或#2格式的JSON对象的路径。
			lru = {
				capacity = 128, -- rust 分析器保存在内存中的语法树数。默认值为 128。
			},
			notifications = {
				cargoTomlNotFound = true, -- 是否显示 can’t find Cargo.toml 错误消息。
			},
			numThreads = nil, -- 主循环中有多少工作线程。默认的 null 表示自动拾取。
			runnables = {
				command = nil,
				extraArgs = {}, -- 要传递给cargo的可运行程序（如测试或二进制文件）的其他参数。例如，它可能是 --release 。
			},
			inlayHints = {
				bindingModeHints = { enable = true },
				chainingHints = { enable = true },
				closingBraceHints = { enable = true, minLines = 40 },
				closureCaptureHints = { enable = true },
				closureReturnTypeHints = { enable = "always" }, -- never
				closureStyle = "impl_fn",
				discriminantHints = { enable = "always" },
				expressionAdjustmentHints = {
					enable = "always",
					hideOutsideUnsafe = false,
					-- mode = "prefix", --[[ postfix ]]
					mode = "postfix ",
				},
				lifetimeElisionHints = { enable = "always", useParameterNames = true },
				maxLength = 25,
				parameterHints = { enable = true },
				renderColons = true,
				typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
			},
			rustfmt = {
				extraArgs = { "--edition=2021" },
				rangeFormatting = { enable = true },
			},
			semanticHighlighting = {
				doc = { comment = { inject = { enable = false } } },
				nonStandardTokens = true,
				operator = {
					enable = true,
					specialization = {
						enable = true, -- 为运算符使用专门的语义标记。
					},
				},
				punctation = {
					enable = true, -- 使用语义标记作为标点符号。
					specialization = {
						enable = true, -- 对标点符号使用专门的语义标记。
					},
					separate = {
						macro = {
							bang = true, -- 启用后，rust分析器将为宏调用的 ! 发出一个标点符号语义标记。
						},
					},
				},
				strings = {
					enable = true,
				},
			},
			signatureInfo = {
				detail = "full",
				documentation = { enable = true },
			},
			typing = {
				autoClosingAngleBrackets = {
					enable = true, -- 键入泛型参数列表的左尖括号时是否插入右尖括号。
				},
			},
			workspace = {
				symbol = {
					search = {
						limit = 128, -- 限制从工作空间符号搜索返回的项目数（默认为128）。
						-- 一些客户端，如vs code，在结果筛选时发布新的搜索，
						-- 并且不要求在初始搜索中返回所有结果。其他客户要求提前获得所有结果，可能需要更高的限额。
						scope = "workspace",
					},
				},
			},
			procMacro = {
				enable = true,
				attributes = { enable = true },
				ignore = {},
				server = nil,
			},
		},
	},
}

M.rls = {
	cmd = { "rls" },
	filetype = { "rust" },
	root_dir = util.root_pattern("Cargo.toml", "rust-project.json"),
	settings = {
		rust = {
			unstable_features = true,
			build_on_save = false,
			all_features = true,
		},
	},
}

return M
