<?php

namespace Pamil\PhpSpecGeneratorExtension\Matcher;

use PhpSpec\Exception\Example\FailureException;
use PhpSpec\Formatter\Presenter\Presenter;
use PhpSpec\Matcher\MatcherInterface;

/**
 * @author Kamil Kokot <kamil@kokot.me>
 */
final class GenerateValuesMatcher implements MatcherInterface
{
    /**
     * @var Presenter
     */
    private $presenter;

    /**
     * @param Presenter $presenter
     */
    public function __construct(Presenter $presenter)
    {
        $this->presenter = $presenter;
    }

    /**
     * {@inheritdoc}
     */
    public function supports($name, $subject, array $arguments)
    {
        return 'generateValues' === $name;
    }

    /**
     * {@inheritdoc}
     */
    public function positiveMatch($name, $subject, array $arguments)
    {
        if (!$subject instanceof \Iterator) {
            throw new FailureException('Subject should be an instance of \Iterator.');
        }

        $toGenerate = count($arguments);
        $generated = 0;
        foreach ($arguments as $expected) {
            if (!$subject->valid()) {
                throw new FailureException(sprintf(
                    'Expected %d elements, but only %d was generated.',
                    $toGenerate,
                    $generated
                ));
            }

            $actual = $subject->current();
            if ($expected !== $actual) {
                throw new FailureException(sprintf(
                    'Element #%d was expected to be %s, but %s was given.',
                    $generated,
                    $this->presenter->presentValue($expected),
                    $this->presenter->presentValue($actual)
                ));
            }

            $subject->next();
            ++$generated;
        }
    }

    /**
     * {@inheritdoc}
     */
    public function negativeMatch($name, $subject, array $arguments)
    {
        try {
            $this->positiveMatch($name, $subject, $arguments);
        } catch (FailureException $exception) {
            return;
        }

        throw new FailureException('Generated values are the same as not expected values.');
    }

    /**
     * {@inheritdoc}
     */
    public function getPriority()
    {
        return 100;
    }
}
