Feature: Magic requires

  Background:
    Given I have a project "cljr" in "tmp"
    And I have a clojure-file "tmp/src/cljr/core.clj"
    And I open file "tmp/src/cljr/core.clj"
    And I clear the buffer

  Scenario: Require is not inserted automagically when in-ns is used
    When I insert:
    """
    (in-ns 'cljr.core)

    (set)
    """
    And I place the cursor after "set"
    And I type "/union"
    Then I should see:
    """
    (in-ns 'cljr.core)

    (set/union)
    """

  Scenario: If alias exists nothing happens
    When I insert:
    """
    (ns cljr.core
      (:require [refactor-nrepl.util :as util]))

    (util)
    """
    And the cache of namespace aliases is populated
    And I place the cursor after "(util"
    And I start an action chain
    And I type "/get-last-sexp"
    And I execute the action chain
    Then I should see:
    """
    (ns cljr.core
      (:require [refactor-nrepl.util :as util]))

    (util/get-last-sexp)
    """

Scenario: Nothing happens when destructuring a map
    When I insert:
    """
    (ns cljr.core)

    (defn f [{:keys [set]}])
    """
    And the cache of namespace aliases is populated
    And I place the cursor after "set"
    And I start an action chain
    And I type "/union"
    And I execute the action chain
    Then I should see:
    """
    (ns cljr.core)

    (defn f [{:keys [set/union]}])
    """
