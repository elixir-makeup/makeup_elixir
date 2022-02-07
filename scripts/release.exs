defmodule Releaser.VersionUtils do
  @doc """
  Some utilities to get and set version numbers in the `mix.exs` file
  and to programmatically transform version numbers.

  Maybe the `bump_*` functions should be in the standard library?

  This script doesn't support pre-release versions or versions with build information.
  """
  @version_line_regex ~r/(\n\s*@version\s+")([^"\n]+)("\n)/

  def bump_major(%Version{} = version) do
    %{version | major: version.major + 1, minor: 0, patch: 0}
  end

  def bump_minor(%Version{} = version) do
    %{version | minor: version.minor + 1, patch: 0}
  end

  def bump_patch(%Version{} = version) do
    %{version | patch: version.patch + 1}
  end

  def version_to_string(%Version{} = version) do
    "#{version.major}.#{version.minor}.#{version.patch}"
  end

  def get_version() do
    # Remove Windows-style line endings
    config =
      "mix.exs"
      |> File.read!()
      |> String.replace("\r", "")

    case Regex.run(@version_line_regex, config) do
      [_line, _pre, version, _post] ->
        Version.parse!(version)

      _ ->
        raise "Invalid project version in your mix.exs file"
    end
  end

  def set_version(version) do
    contents = File.read!("mix.exs")
    version_string = version_to_string(version)

    replaced =
      Regex.replace(@version_line_regex, contents, fn _, pre, _version, post ->
        "#{pre}#{version_string}#{post}"
      end)

    File.write!("mix.exs", replaced)
  end

  def update_version(%Version{} = version, "major"), do: bump_major(version)
  def update_version(%Version{} = version, "minor"), do: bump_minor(version)
  def update_version(%Version{} = version, "patch"), do: bump_patch(version)
  def update_version(%Version{} = _version, type), do: raise("Invalid version type: #{type}")
end

defmodule Releaser.Changelog do
  @doc """
  Functions to append entries to the changelog.
  """
  alias Releaser.VersionUtils

  @release_filename "RELEASE.md"
  @release_type_regex ~r/^(RELEASE_TYPE:\s+)(\w+)(.*)/s

  @changelog_filename "CHANGELOG.md"
  @changelog_entry_header_level 3
  @changelog_entries_marker "\n<!-- %% CHANGELOG_ENTRIES %% -->\n"

  def remove_release_file() do
    File.rm!(@release_filename)
  end

  def extract_release_type() do
    # Remove Windows line endings
    contents =
      @release_filename
      |> File.read!()
      |> String.replace("\r", "")

    {type, text} =
      case Regex.run(@release_type_regex, contents) |> IO.inspect() do
        [_line, _pre, type, text] ->
          {type, String.trim(text)}

        _ ->
          raise "Invalid project version in your mix.exs file"
      end

    {type, text}
  end

  def changelog_entry(%Version{} = version, %DateTime{} = date_time, text) do
    header_prefix = String.duplicate("#", @changelog_entry_header_level)
    version_string = VersionUtils.version_to_string(version)

    date_time_string =
      date_time
      |> DateTime.truncate(:second)
      |> NaiveDateTime.to_string()

    """

    #{header_prefix} #{version_string} - #{date_time_string}

    #{text}

    """
  end

  def add_changelog_entry(entry) do
    contents =
      @changelog_filename
      |> File.read!()
      |> String.replace("\r", "")
      
    [first, last] = String.split(contents, @changelog_entries_marker)

    replaced =
      Enum.join([
        first,
        @changelog_entries_marker,
        entry,
        last
      ])

    File.write!(@changelog_filename, replaced)
  end
end

defmodule Releaser.Git do
  @doc """
  This module contains some git-specific functionality
  """
  alias Releaser.VersionUtils

  def add_commit_and_tag(version) do
    version_string = VersionUtils.version_to_string(version)
    Mix.Shell.IO.cmd("git add .", [])
    Mix.Shell.IO.cmd(~s'git commit -m "Bumped version number"')
    Mix.Shell.IO.cmd(~s'git tag -a v#{version_string} -m "Version #{version_string}"')
  end
end

defmodule Releaser.Tests do
  def run_tests!() do
    error_code = Mix.Shell.IO.cmd("mix test", [])

    if error_code != 0 do
      raise "This version can't be released because tests are failing."
    end

    :ok
  end
end

defmodule Releaser do
  alias Releaser.VersionUtils
  alias Releaser.Changelog
  alias Releaser.Git
  alias Releaser.Tests
  alias Releaser.Publish

  def run() do
    # Run the tests before generating the release.
    # If any test fails, stop.
    Tests.run_tests!()
    # Get the current version from the mix.exs file.
    version = VersionUtils.get_version()
    # Extract the changelog entry and add it to the changelog.
    # Use the information in the RELEASE.md file to bump the version number.
    {release_type, text} = Changelog.extract_release_type()
    new_version = VersionUtils.update_version(version, release_type)
    entry = Changelog.changelog_entry(new_version, DateTime.utc_now(), text)
    Changelog.add_changelog_entry(entry)
    # Set a new version on the mix.exs file
    VersionUtils.set_version(new_version)
    # Commit the changes and ad a new 'v*.*.*' tag
    Git.add_commit_and_tag(new_version)
    # Now that we have committed the changes, we can remove the release file
    Changelog.remove_release_file()
  end
end

# Generate a new release
Releaser.run()
